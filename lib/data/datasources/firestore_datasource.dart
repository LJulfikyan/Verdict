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

  Future<QuerySnapshot<Map<String, dynamic>>> fetchCases({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = AppConstants.defaultFeedPageSize,
  }) {
    Query<Map<String, dynamic>> query = casesCollection
        .where('status', isEqualTo: 'active')
        .orderBy('hotScore', descending: true)
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream(
    String userId,
  ) {
    return usersCollection
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
