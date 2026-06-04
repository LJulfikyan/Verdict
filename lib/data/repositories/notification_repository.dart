import '../../core/constants/api_constants.dart';
import '../../core/services/debug_logger.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/functions_datasource.dart';
import '../datasources/notification_datasource.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  NotificationRepository({
    required FirebaseAuthDataSource authDataSource,
    required NotificationDataSource notificationDataSource,
    required FunctionsDataSource functionsDataSource,
  }) : _authDataSource = authDataSource,
       _notificationDataSource = notificationDataSource,
       _functionsDataSource = functionsDataSource;

  final FirebaseAuthDataSource _authDataSource;
  final NotificationDataSource _notificationDataSource;
  final FunctionsDataSource _functionsDataSource;

  Stream<List<NotificationModel>> notifications(String userId) {
    return _notificationDataSource
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
    try {
      await _functionsDataSource.call(
        ApiConstants.markNotificationRead,
        parameters: {'notificationId': notificationId},
      );
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'NotificationRepository',
        method: 'markRead',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {'notificationId': notificationId},
      );
      rethrow;
    }
  }

  Future<void> markAllRead(Iterable<String> notificationIds) async {
    final currentUser = _authDataSource.currentUser;
    if (currentUser == null) {
      throw StateError('User must be authenticated to update notifications.');
    }
    try {
      for (final notificationId in notificationIds) {
        await _functionsDataSource.call(
          ApiConstants.markNotificationRead,
          parameters: {'notificationId': notificationId},
        );
      }
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'NotificationRepository',
        method: 'markAllRead',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {'notificationIds': notificationIds.toList()},
      );
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final currentUser = _authDataSource.currentUser;
    if (currentUser == null) {
      throw StateError('User must be authenticated to delete notifications.');
    }
    try {
      await _notificationDataSource.delete(
        userId: currentUser.uid,
        notificationId: notificationId,
      );
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'NotificationRepository',
        method: 'deleteNotification',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {'notificationId': notificationId},
      );
      rethrow;
    }
  }
}
