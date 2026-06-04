import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../datasources/firestore_datasource.dart';
import '../models/case_feed_page.dart';
import '../models/case_model.dart';
import '../models/profile_statistics_model.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository({required FirestoreDataSource firestoreDataSource})
    : _firestoreDataSource = firestoreDataSource;

  final FirestoreDataSource _firestoreDataSource;

  Future<UserModel?> getUser(String userId) async {
    final snapshot = await _firestoreDataSource.getUser(userId);
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    return UserModel.fromMap(data, id: snapshot.id);
  }

  Future<void> createOrUpdateFromAuthUser(User user) async {
    final provider = user.isAnonymous
        ? 'guest'
        : user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : 'unknown';

    await _firestoreDataSource.setUser(user.uid, {
      'id': user.uid,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'provider': provider,
      'premium': false,
      'createdAt': user.metadata.creationTime,
      'lastSeenAt': DateTime.now(),
      'casesCount': 0,
      'votesCount': 0,
      'savedCount': 0,
      'reportsCount': 0,
      'agreementScore': 0,
      'country': null,
      'gender': null,
      'ageRange': null,
      'isBanned': false,
    });
  }

  Future<void> updateLastSeen(String userId) {
    return _firestoreDataSource.updateUser(userId, {
      'lastSeenAt': DateTime.now(),
    });
  }

  Future<Set<String>> getSavedCaseIds(String userId) async {
    final snapshot = await _firestoreDataSource.fetchSavedCases(userId);
    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  Future<ProfileStatisticsModel> getProfileStatistics(String userId) async {
    final snapshot = await _firestoreDataSource.getUser(userId);
    final data = snapshot.data() ?? const <String, dynamic>{};

    int? casesPosted = _readIntIfPresent(data, 'casesCount');
    int? votesReceived = _readIntIfPresent(data, 'votesCount');
    int? savedCasesCount = _readIntIfPresent(data, 'savedCount');
    final agreementScore = _readIntIfPresent(data, 'agreementScore') ?? 0;

    if (casesPosted == null || votesReceived == null) {
      final authoredCases = await _firestoreDataSource.fetchCasesByAuthor(
        userId,
      );
      casesPosted ??= authoredCases.docs.length;
      votesReceived ??= authoredCases.docs.fold<int>(
        0,
        (totalVotes, doc) =>
            totalVotes + ((doc.data()['votesCount'] as num?)?.toInt() ?? 0),
      );
    }

    if (savedCasesCount == null) {
      final savedCases = await _firestoreDataSource.fetchSavedCases(userId);
      savedCasesCount = savedCases.docs.length;
    }

    final resolvedCasesPosted = casesPosted;
    final resolvedVotesReceived = votesReceived;
    final resolvedSavedCasesCount = savedCasesCount;

    return ProfileStatisticsModel(
      casesPosted: resolvedCasesPosted,
      votesReceived: resolvedVotesReceived,
      savedCasesCount: resolvedSavedCasesCount,
      agreementScore: agreementScore,
    );
  }

  Future<CaseFeedPage> getSavedCasesPage({
    required String userId,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 20,
  }) async {
    final snapshot = await _firestoreDataSource.fetchSavedCasesPage(
      userId: userId,
      startAfter: startAfter,
      limit: limit,
    );
    final caseIds = snapshot.docs
        .map((doc) => (doc.data()['caseId'] as String?) ?? doc.id)
        .where((id) => id.isNotEmpty)
        .toList(growable: false);
    final caseDocuments = await _firestoreDataSource.fetchCasesByIds(caseIds);
    final items = caseDocuments
        .where((doc) => doc.exists && doc.data() != null)
        .map((doc) => CaseModel.fromMap(doc.data()!, id: doc.id))
        .where((item) => item.isActive)
        .toList(growable: false);

    return CaseFeedPage(
      items: items,
      lastDocument: snapshot.docs.isEmpty ? null : snapshot.docs.last,
      hasMore: snapshot.docs.length == limit,
    );
  }

  Future<void> updateMessagingToken(String userId, String token) {
    return _firestoreDataSource.updateUser(userId, {
      'fcmToken': token,
      'fcmTokenUpdatedAt': DateTime.now(),
    });
  }

  int? _readIntIfPresent(Map<String, dynamic> data, String key) {
    if (!data.containsKey(key)) {
      return null;
    }
    return (data[key] as num?)?.toInt() ?? 0;
  }
}
