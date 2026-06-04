'use strict';

const admin = require('firebase-admin');
const {HttpsError, onCall} = require('firebase-functions/v2/https');
const {logger} = require('firebase-functions');

admin.initializeApp();

const db = admin.firestore();
const FieldValue = admin.firestore.FieldValue;

const CASES_COLLECTION = 'cases';
const USERS_COLLECTION = 'users';
const ANALYTICS_COLLECTION = 'analytics_events';
const VALID_VOTE_OPTIONS = new Set([
  'youRight',
  'theyRight',
  'bothWrong',
  'needInfo',
]);

exports['votes/voteCase'] = onCall({region: 'us-central1'}, async (request) => {
  const userId = request.auth?.uid;
  if (!userId) {
    throw new HttpsError('unauthenticated', 'unauthorized');
  }

  const caseId = `${request.data?.caseId ?? ''}`.trim();
  const option = `${request.data?.option ?? ''}`.trim();

  if (!caseId) {
    throw new HttpsError('invalid-argument', 'case_id_required');
  }
  if (!VALID_VOTE_OPTIONS.has(option)) {
    throw new HttpsError('invalid-argument', 'invalid_vote_option');
  }

  const userRef = db.collection(USERS_COLLECTION).doc(userId);
  const caseRef = db.collection(CASES_COLLECTION).doc(caseId);
  const voteRef = caseRef.collection('votes').doc(userId);
  const analyticsRef = db.collection(ANALYTICS_COLLECTION).doc();

  try {
    const result = await db.runTransaction(async (transaction) => {
      const [userSnapshot, caseSnapshot, voteSnapshot] = await Promise.all([
        transaction.get(userRef),
        transaction.get(caseRef),
        transaction.get(voteRef),
      ]);

      if (!userSnapshot.exists) {
        throw new HttpsError('permission-denied', 'permission_denied');
      }

      const userData = userSnapshot.data() ?? {};
      if (userData.isBanned === true) {
        throw new HttpsError('permission-denied', 'permission_denied');
      }

      if (!caseSnapshot.exists) {
        throw new HttpsError('not-found', 'case_deleted');
      }

      if (voteSnapshot.exists) {
        throw new HttpsError('already-exists', 'duplicate_vote');
      }

      const caseData = caseSnapshot.data() ?? {};
      if (caseData.status !== 'active') {
        throw new HttpsError('failed-precondition', 'case_deleted');
      }

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

      return {
        results: currentResults,
        votesCount,
        winnerOption,
        hotScore,
        relationshipType: `${caseData.relationshipType ?? ''}`,
        category: `${caseData.category ?? ''}`,
      };
    });

    logger.info('voteCase success', {
      caseId,
      userId,
      option,
    });

    return {
      success: true,
      ...result,
    };
  } catch (error) {
    logger.error('voteCase failed', {
      caseId,
      userId,
      option,
      error: error instanceof Error ? error.message : String(error),
    });

    if (error instanceof HttpsError) {
      throw error;
    }

    throw new HttpsError('internal', 'vote_failed');
  }
});

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
