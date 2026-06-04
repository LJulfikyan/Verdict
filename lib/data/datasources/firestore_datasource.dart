import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_constants.dart';

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

  Future<QuerySnapshot<Map<String, dynamic>>> fetchCases({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = AppConstants.defaultFeedPageSize,
    String? category,
    String? relationshipType,
  }) {
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
    return casesCollection.doc(caseId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchCase(String caseId) {
    return casesCollection.doc(caseId).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) {
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
    return savedCasesCollection(userId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchVote({
    required String caseId,
    required String userId,
  }) {
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
    return notificationsCollection(
      userId,
    ).orderBy('createdAt', descending: true).snapshots();
  }
}
