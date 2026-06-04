'use strict';

const admin = require('firebase-admin');
const {HttpsError, onCall} = require('firebase-functions/v2/https');
const {logger} = require('firebase-functions');

admin.initializeApp();

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

const REGION = 'us-central1';
const CASES_COLLECTION = 'cases';
const USERS_COLLECTION = 'users';
const ANALYTICS_COLLECTION = 'analytics_events';
const NOTIFICATION_MILESTONES = [100, 500, 1000, 5000];
const REPORT_HIDE_THRESHOLD = 5;
const VALID_VOTE_OPTIONS = new Set([
  'youRight',
  'theyRight',
  'bothWrong',
  'needInfo',
]);
const VALID_REPORT_REASONS = new Set([
  'spam',
  'fake_story',
  'personal_information',
  'harassment',
  'other',
]);

exports.voteCase = onCall({region: REGION}, async (request) => {
  const {userId, userRef, userData} = await requireParticipantUser(request);

  const caseId = `${request.data?.caseId ?? ''}`.trim();
  const option = `${request.data?.option ?? ''}`.trim();

  if (!caseId) {
    throw fail('invalid-argument', 'case_id_required');
  }
  if (!VALID_VOTE_OPTIONS.has(option)) {
    throw fail('invalid-argument', 'invalid_vote_option');
  }

  const caseRef = db.collection(CASES_COLLECTION).doc(caseId);
  const voteRef = caseRef.collection('votes').doc(userId);
  const analyticsRef = db.collection(ANALYTICS_COLLECTION).doc();

  try {
    const result = await db.runTransaction(async (transaction) => {
      const [caseSnapshot, voteSnapshot] = await Promise.all([
        transaction.get(caseRef),
        transaction.get(voteRef),
      ]);

      if (!caseSnapshot.exists) {
        throw fail('not-found', 'case_deleted');
      }

      if (voteSnapshot.exists) {
        throw fail('already-exists', 'duplicate_vote');
      }

      const caseData = caseSnapshot.data() ?? {};
      ensureActiveCase(caseData);

      const currentResults = normalizeResults(caseData.results);
      currentResults[option] += 1;
      const votesCount = Number(caseData.votesCount ?? 0) + 1;
      const winnerOption = calculateWinnerOption(currentResults);
      const hotScore = calculateHotScore({
        votesCount,
        sharesCount: Number(caseData.sharesCount ?? 0),
        savesCount: Number(caseData.savesCount ?? 0),
        createdAt: caseData.createdAt,
      });

      transaction.set(voteRef, {
        userId,
        caseId,
        option,
        createdAt: FieldValue.serverTimestamp(),
      });

      transaction.update(caseRef, {
        results: currentResults,
        votesCount,
        winnerOption,
        hotScore,
        updatedAt: FieldValue.serverTimestamp(),
      });

      transaction.set(
        userRef,
        {
          votesCount: FieldValue.increment(1),
          lastSeenAt: FieldValue.serverTimestamp(),
        },
        {merge: true},
      );

      transaction.set(analyticsRef, {
        userId,
        eventName: 'case_vote',
        createdAt: FieldValue.serverTimestamp(),
        payload: {
          caseId,
          voteOption: option,
          relationshipType: `${caseData.relationshipType ?? ''}`,
          category: `${caseData.category ?? ''}`,
        },
      });

      maybeCreateMilestoneNotification(transaction, {
        caseData,
        caseId,
        votesCount,
      });

      return {
        results: currentResults,
        votesCount,
        winnerOption,
        hotScore,
      };
    });

    logger.info('voteCase success', {caseId, userId, provider: userData.provider});
    return {success: true, ...result};
  } catch (error) {
    logFunctionError('voteCase', error, {caseId, userId});
    throw normalizeFunctionError(error, 'vote_failed');
  }
});

exports.createCase = onCall({region: REGION}, async (request) => {
  const {userId, userRef, userData} = await requireParticipantUser(request);

  const relationshipType = `${request.data?.relationshipType ?? ''}`.trim();
  const category = `${request.data?.category ?? ''}`.trim();
  const description = `${request.data?.description ?? ''}`.trim();
  const question = `${request.data?.question ?? ''}`.trim();

  validateCasePayload({
    relationshipType,
    category,
    description,
    question,
  });

  const caseRef = db.collection(CASES_COLLECTION).doc();
  const analyticsRef = db.collection(ANALYTICS_COLLECTION).doc();
  const now = FieldValue.serverTimestamp();

  try {
    await db.runTransaction(async (transaction) => {
      transaction.set(caseRef, {
        authorId: userId,
        relationshipType,
        category,
        description,
        question,
        status: 'active',
        createdAt: now,
        updatedAt: now,
        votesCount: 0,
        viewsCount: 0,
        savesCount: 0,
        reportsCount: 0,
        sharesCount: 0,
        hotScore: 0,
        winnerOption: '',
        resultVisible: true,
        results: normalizeResults(),
      });

      transaction.set(
        userRef,
        {
          casesCount: FieldValue.increment(1),
          lastSeenAt: now,
        },
        {merge: true},
      );

      transaction.set(analyticsRef, {
        userId,
        eventName: 'case_created',
        createdAt: now,
        payload: {
          caseId: caseRef.id,
          relationshipType,
          category,
        },
      });
    });

    logger.info('createCase success', {caseId: caseRef.id, userId, provider: userData.provider});
    return {success: true, caseId: caseRef.id};
  } catch (error) {
    logFunctionError('createCase', error, {userId});
    throw normalizeFunctionError(error, 'create_case_failed');
  }
});

exports.saveCase = onCall({region: REGION}, async (request) => {
  const {userId, userRef} = await requireParticipantUser(request);
  const caseId = `${request.data?.caseId ?? ''}`.trim();

  if (!caseId) {
    throw fail('invalid-argument', 'case_id_required');
  }

  const caseRef = db.collection(CASES_COLLECTION).doc(caseId);
  const savedCaseRef = userRef.collection('saved_cases').doc(caseId);
  const analyticsRef = db.collection(ANALYTICS_COLLECTION).doc();

  try {
    const result = await db.runTransaction(async (transaction) => {
      const [caseSnapshot, savedSnapshot] = await Promise.all([
        transaction.get(caseRef),
        transaction.get(savedCaseRef),
      ]);

      if (!caseSnapshot.exists) {
        throw fail('not-found', 'case_deleted');
      }

      const caseData = caseSnapshot.data() ?? {};
      ensureActiveCase(caseData);

      const isSaved = savedSnapshot.exists;
      const savesDelta = isSaved ? -1 : 1;
      const savesCount = Math.max(0, Number(caseData.savesCount ?? 0) + savesDelta);
      const hotScore = calculateHotScore({
        votesCount: Number(caseData.votesCount ?? 0),
        sharesCount: Number(caseData.sharesCount ?? 0),
        savesCount,
        createdAt: caseData.createdAt,
      });

      if (isSaved) {
        transaction.delete(savedCaseRef);
      } else {
        transaction.set(savedCaseRef, {
          caseId,
          savedAt: FieldValue.serverTimestamp(),
        });
      }

      transaction.update(caseRef, {
        savesCount,
        hotScore,
        updatedAt: FieldValue.serverTimestamp(),
      });

      transaction.set(
        userRef,
        {
          savedCount: FieldValue.increment(isSaved ? -1 : 1),
          lastSeenAt: FieldValue.serverTimestamp(),
        },
        {merge: true},
      );

      transaction.set(analyticsRef, {
        userId,
        eventName: 'case_saved',
        createdAt: FieldValue.serverTimestamp(),
        payload: {
          caseId,
          saved: !isSaved,
        },
      });

      return {saved: !isSaved};
    });

    logger.info('saveCase success', {caseId, userId, saved: result.saved});
    return {success: true, ...result};
  } catch (error) {
    logFunctionError('saveCase', error, {caseId, userId});
    throw normalizeFunctionError(error, 'save_case_failed');
  }
});

exports.reportCase = onCall({region: REGION}, async (request) => {
  const {userId, userRef} = await requireParticipantUser(request);
  const caseId = `${request.data?.caseId ?? ''}`.trim();
  const reason = `${request.data?.reason ?? ''}`.trim();

  if (!caseId) {
    throw fail('invalid-argument', 'case_id_required');
  }
  if (!VALID_REPORT_REASONS.has(reason)) {
    throw fail('invalid-argument', 'invalid_report_reason');
  }

  const caseRef = db.collection(CASES_COLLECTION).doc(caseId);
  const reportRef = caseRef.collection('reports').doc();
  const analyticsRef = db.collection(ANALYTICS_COLLECTION).doc();

  try {
    await db.runTransaction(async (transaction) => {
      const caseSnapshot = await transaction.get(caseRef);
      if (!caseSnapshot.exists) {
        throw fail('not-found', 'case_deleted');
      }

      const caseData = caseSnapshot.data() ?? {};
      ensureActiveCase(caseData);

      const reportsCount = Number(caseData.reportsCount ?? 0) + 1;
      const nextStatus = reportsCount >= REPORT_HIDE_THRESHOLD ? 'hidden' : 'active';

      transaction.set(reportRef, {
        userId,
        reason,
        createdAt: FieldValue.serverTimestamp(),
      });

      transaction.update(caseRef, {
        reportsCount,
        status: nextStatus,
        updatedAt: FieldValue.serverTimestamp(),
      });

      transaction.set(
        userRef,
        {
          reportsCount: FieldValue.increment(1),
          lastSeenAt: FieldValue.serverTimestamp(),
        },
        {merge: true},
      );

      transaction.set(analyticsRef, {
        userId,
        eventName: 'case_reported',
        createdAt: FieldValue.serverTimestamp(),
        payload: {
          caseId,
          reason,
          reportsCount,
          hidden: nextStatus == 'hidden',
        },
      });
    });

    logger.info('reportCase success', {caseId, userId, reason});
    return {success: true};
  } catch (error) {
    logFunctionError('reportCase', error, {caseId, userId, reason});
    throw normalizeFunctionError(error, 'report_case_failed');
  }
});

exports.markNotificationRead = onCall({region: REGION}, async (request) => {
  const {userId, userRef} = await requireParticipantUser(request);

  const notificationId = `${request.data?.notificationId ?? ''}`.trim();
  if (!notificationId) {
    throw fail('invalid-argument', 'notification_id_required');
  }

  const notificationRef = userRef.collection('notifications').doc(notificationId);

  try {
    await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(notificationRef);
      if (!snapshot.exists) {
        throw fail('not-found', 'notification_not_found');
      }
      transaction.update(notificationRef, {
        isRead: true,
      });
    });

    logger.info('markNotificationRead success', {notificationId, userId});
    return {success: true};
  } catch (error) {
    logFunctionError('markNotificationRead', error, {notificationId, userId});
    throw normalizeFunctionError(error, 'mark_notification_read_failed');
  }
});

async function requireParticipantUser(request) {
  const userId = request.auth?.uid;
  if (!userId) {
    throw fail('unauthenticated', 'unauthorized');
  }

  const userRef = db.collection(USERS_COLLECTION).doc(userId);
  const userSnapshot = await userRef.get();
  if (!userSnapshot.exists) {
    throw fail('permission-denied', 'user_not_found');
  }

  const userData = userSnapshot.data() ?? {};
  if (userData.isBanned === true) {
    throw fail('permission-denied', 'user_banned');
  }
  if (`${userData.provider ?? ''}` === 'guest') {
    throw fail('permission-denied', 'guest_not_allowed');
  }

  return {userId, userRef, userData};
}

function validateCasePayload({
  relationshipType,
  category,
  description,
  question,
}) {
  if (!relationshipType) {
    throw fail('invalid-argument', 'invalid_relationship_type');
  }
  if (!category) {
    throw fail('invalid-argument', 'invalid_category');
  }
  if (description.length < 50) {
    throw fail('invalid-argument', 'description_too_short');
  }
  if (description.length > 500) {
    throw fail('invalid-argument', 'description_too_long');
  }
  if (question.length < 1 || question.length > 100) {
    throw fail('invalid-argument', 'invalid_question_length');
  }
}

function ensureActiveCase(caseData) {
  if (`${caseData.status ?? ''}` !== 'active') {
    throw fail('failed-precondition', 'case_deleted');
  }
}

function normalizeResults(results) {
  const normalized = {
    youRight: 0,
    theyRight: 0,
    bothWrong: 0,
    needInfo: 0,
  };

  if (results && typeof results === 'object') {
    for (const key of Object.keys(normalized)) {
      normalized[key] = Number(results[key] ?? 0);
    }
  }

  return normalized;
}

function calculateWinnerOption(results) {
  return Object.entries(results).reduce(
    (winner, entry) => (entry[1] > winner.count ? {option: entry[0], count: entry[1]} : winner),
    {option: '', count: -1},
  ).option;
}

function calculateHotScore({votesCount, sharesCount, savesCount, createdAt}) {
  const createdDate = parseTimestamp(createdAt);
  const ageHours = createdDate
    ? (Date.now() - createdDate.getTime()) / (1000 * 60 * 60)
    : Number.POSITIVE_INFINITY;

  let freshnessBoost = 0;
  if (ageHours <= 3) {
    freshnessBoost = 100;
  } else if (ageHours <= 24) {
    freshnessBoost = 25;
  }

  return (votesCount * 4) + (sharesCount * 6) + (savesCount * 2) + freshnessBoost;
}

function parseTimestamp(value) {
  if (!value) {
    return null;
  }
  if (typeof value.toDate === 'function') {
    return value.toDate();
  }
  if (value instanceof Date) {
    return value;
  }
  const parsed = new Date(value);
  return Number.isNaN(parsed.getTime()) ? null : parsed;
}

function maybeCreateMilestoneNotification(transaction, {caseData, caseId, votesCount}) {
  const milestone = NOTIFICATION_MILESTONES.find((value) => value === votesCount);
  const authorId = `${caseData.authorId ?? ''}`;
  if (!milestone || !authorId) {
    return;
  }

  const notificationRef = db
    .collection(USERS_COLLECTION)
    .doc(authorId)
    .collection('notifications')
    .doc();
  transaction.set(notificationRef, buildMilestoneNotification({milestone, caseId}));
}

function buildMilestoneNotification({milestone, caseId}) {
  return {
    title: 'Case milestone',
    body: milestone === 5000
      ? 'Your case is going viral.'
      : `Your case reached ${milestone.toLocaleString()} votes.`,
    type: 'case_milestone',
    targetId: caseId,
    isRead: false,
    createdAt: FieldValue.serverTimestamp(),
  };
}

function logFunctionError(name, error, context) {
  logger.error(`${name} failed`, {
    ...context,
    error: error instanceof Error ? error.message : String(error),
  });
}

function normalizeFunctionError(error, fallbackCode) {
  if (error instanceof HttpsError) {
    return error;
  }
  return fail('internal', fallbackCode);
}

function fail(code, message) {
  return new HttpsError(code, message, {
    success: false,
    error: {
      code,
      message,
    },
  });
}
