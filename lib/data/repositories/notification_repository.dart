import '../../core/constants/api_constants.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/functions_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  NotificationRepository({
    required FirebaseAuthDataSource authDataSource,
    required FirestoreDataSource firestoreDataSource,
    required FunctionsDataSource functionsDataSource,
  }) : _authDataSource = authDataSource,
       _firestoreDataSource = firestoreDataSource,
       _functionsDataSource = functionsDataSource;

  final FirebaseAuthDataSource _authDataSource;
  final FirestoreDataSource _firestoreDataSource;
  final FunctionsDataSource _functionsDataSource;

  Stream<List<NotificationModel>> notifications(String userId) {
    return _firestoreDataSource
        .notificationsStream(userId)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), id: doc.id))
              .toList(growable: false),
        );
  }

  Future<void> markRead(String notificationId) async {
    final currentUser = _authDataSource.currentUser;
    if (currentUser == null) {
      throw StateError('User must be authenticated to update notifications.');
    }
    await _firestoreDataSource.updateNotificationRead(
      userId: currentUser.uid,
      notificationId: notificationId,
      isRead: true,
    );
  }

  Future<void> markReadViaFunction(String notificationId) {
    return _functionsDataSource.call(
      ApiConstants.markNotificationRead,
      parameters: {'notificationId': notificationId},
    );
  }
}
