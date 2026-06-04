import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_datasource.dart';

class NotificationDataSource {
  NotificationDataSource({required FirestoreDataSource firestoreDataSource})
    : _firestoreDataSource = firestoreDataSource;

  final FirestoreDataSource _firestoreDataSource;

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationsStream(
    String userId,
  ) {
    return _firestoreDataSource.notificationsCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> markRead({
    required String userId,
    required String notificationId,
  }) {
    return _firestoreDataSource
        .notificationsCollection(userId)
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllRead({
    required String userId,
    required Iterable<String> notificationIds,
  }) async {
    final batch = _firestoreDataSource.usersCollection.firestore.batch();
    for (final notificationId in notificationIds) {
      batch.update(
        _firestoreDataSource.notificationsCollection(userId).doc(notificationId),
        {'isRead': true},
      );
    }
    await batch.commit();
  }

  Future<void> delete({
    required String userId,
    required String notificationId,
  }) {
    return _firestoreDataSource
        .notificationsCollection(userId)
        .doc(notificationId)
        .delete();
  }
}
