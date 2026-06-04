import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/debug_logger.dart';

class FirestoreDataSource {
  FirestoreDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get casesCollection =>
      _firestore.collection('cases');
  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');
  Query<Map<String, dynamic>> get reportsCollection =>
      _firestore.collectionGroup('reports');
  Query<Map<String, dynamic>> authoredCasesQuery(String userId) =>
      casesCollection.where('authorId', isEqualTo: userId);

  Future<QuerySnapshot<Map<String, dynamic>>> fetchCases({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = AppConstants.defaultFeedPageSize,
    String? category,
    String? relationshipType,
  }) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'fetchCases',
      query: 'cases.where(status == active).orderBy(hotScore desc)',
      parameters: {
        'startAfter': startAfter?.id,
        'limit': limit,
        'category': category,
        'relationshipType': relationshipType,
      },
    );
    Query<Map<String, dynamic>> query = casesCollection
        .where('status', isEqualTo: 'active')
        .orderBy('hotScore', descending: true);
    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    if (relationshipType != null && relationshipType.isNotEmpty) {
      query = query.where('relationshipType', isEqualTo: relationshipType);
    }
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query
        .limit(limit)
        .get(const GetOptions(source: Source.serverAndCache));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCase(String caseId) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'getCase',
      query: 'cases.doc(caseId).get()',
      parameters: {'caseId': caseId},
    );
    return casesCollection.doc(caseId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchCase(String caseId) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'watchCase',
      query: 'cases.doc(caseId).snapshots()',
      parameters: {'caseId': caseId},
    );
    return casesCollection.doc(caseId).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'getUser',
      query: 'users.doc(userId).get()',
      parameters: {'userId': userId},
    );
    return usersCollection.doc(userId).get();
  }

  Future<void> setUser(
    String userId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) {
    return usersCollection.doc(userId).set(data, SetOptions(merge: merge));
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) {
    return usersCollection.doc(userId).update(data);
  }

  Future<void> setUserFields(String userId, Map<String, dynamic> data) {
    return usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }

  CollectionReference<Map<String, dynamic>> savedCasesCollection(
    String userId,
  ) {
    return usersCollection.doc(userId).collection('saved_cases');
  }

  CollectionReference<Map<String, dynamic>> notificationsCollection(
    String userId,
  ) {
    return usersCollection.doc(userId).collection('notifications');
  }

  CollectionReference<Map<String, dynamic>> votesCollection(String caseId) {
    return casesCollection.doc(caseId).collection('votes');
  }

  CollectionReference<Map<String, dynamic>> reportsForCaseCollection(
    String caseId,
  ) {
    return casesCollection.doc(caseId).collection('reports');
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchSavedCases(String userId) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'fetchSavedCases',
      query: 'users/{userId}/saved_cases.get()',
      parameters: {'userId': userId},
    );
    return savedCasesCollection(userId).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchSavedCasesPage({
    required String userId,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 20,
  }) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'fetchSavedCasesPage',
      query: 'users/{userId}/saved_cases.orderBy(savedAt desc)',
      parameters: {
        'userId': userId,
        'startAfter': startAfter?.id,
        'limit': limit,
      },
    );
    Query<Map<String, dynamic>> query = savedCasesCollection(
      userId,
    ).orderBy('savedAt', descending: true);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query
        .limit(limit)
        .get(const GetOptions(source: Source.serverAndCache));
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> fetchCasesByIds(
    List<String> caseIds,
  ) async {
    if (caseIds.isEmpty) {
      return const [];
    }
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'fetchCasesByIds',
      query: 'cases.where(documentId in chunk)',
      parameters: {'caseIds': caseIds},
    );

    final snapshots = await Future.wait([
      for (int index = 0; index < caseIds.length; index += 10)
        casesCollection
            .where(
              FieldPath.documentId,
              whereIn: caseIds.sublist(
                index,
                index + 10 > caseIds.length ? caseIds.length : index + 10,
              ),
            )
            .get(const GetOptions(source: Source.serverAndCache)),
    ]);

    final byId = <String, DocumentSnapshot<Map<String, dynamic>>>{};
    for (final snapshot in snapshots) {
      for (final doc in snapshot.docs) {
        byId[doc.id] = doc;
      }
    }

    return caseIds
        .map((id) => byId[id])
        .whereType<DocumentSnapshot<Map<String, dynamic>>>()
        .toList(growable: false);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchCasesByAuthor(
    String userId,
  ) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'fetchCasesByAuthor',
      query: 'cases.where(authorId == userId)',
      parameters: {'userId': userId},
    );
    return authoredCasesQuery(
      userId,
    ).get(const GetOptions(source: Source.serverAndCache));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchVote({
    required String caseId,
    required String userId,
  }) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'fetchVote',
      query: 'cases/{caseId}/votes/{userId}.get()',
      parameters: {'caseId': caseId, 'userId': userId},
    );
    return votesCollection(caseId).doc(userId).get();
  }

  Future<void> updateNotificationRead({
    required String userId,
    required String notificationId,
    required bool isRead,
  }) {
    return notificationsCollection(
      userId,
    ).doc(notificationId).update({'isRead': isRead});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream(
    String userId,
  ) {
    DebugLogger.logQuery(
      module: 'Firestore',
      className: 'FirestoreDataSource',
      method: 'notificationsStream',
      query: 'users/{userId}/notifications.orderBy(createdAt desc)',
      parameters: {'userId': userId},
    );
    return notificationsCollection(
      userId,
    ).orderBy('createdAt', descending: true).snapshots();
  }
}
