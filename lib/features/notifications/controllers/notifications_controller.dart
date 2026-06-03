import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  NotificationsController({
    required NotificationRepository repository,
    required AuthService authService,
  }) : _repository = repository,
       _authService = authService;

  final NotificationRepository _repository;
  final AuthService _authService;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<List<NotificationModel>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      return;
    }
    isLoading.value = true;
    _subscription?.cancel();
    _subscription = _repository.notifications(userId).listen((items) {
      notifications.assignAll(items);
      unreadCount.value = items.where((item) => !item.isRead).length;
      isLoading.value = false;
    });
  }

  Future<void> markRead(NotificationModel notification) async {
    await _repository.markRead(notification.id);
  }

  Future<void> markAllRead() async {
    for (final notification in notifications.where((item) => !item.isRead)) {
      await markRead(notification);
    }
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((item) => item.id == notificationId);
    unreadCount.value = notifications.where((item) => !item.isRead).length;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
