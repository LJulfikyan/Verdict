import '../../core/constants/api_constants.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/functions_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  NotificationRepository({
    required FirestoreDataSource firestoreDataSource,
    required FunctionsDataSource functionsDataSource,
  }) : _firestoreDataSource = firestoreDataSource,
       _functionsDataSource = functionsDataSource;

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
    await _functionsDataSource.call(
      ApiConstants.markNotificationRead,
      parameters: {'notificationId': notificationId},
    );
  }
}
