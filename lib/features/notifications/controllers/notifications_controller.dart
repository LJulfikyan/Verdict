import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  NotificationsController({
    required NotificationRepository repository,
    required AuthService authService,
    required AnalyticsService analyticsService,
    required NotificationService notificationService,
  }) : _repository = repository,
       _authService = authService,
       _analyticsService = analyticsService,
       _notificationService = notificationService;

  final NotificationRepository _repository;
  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final NotificationService _notificationService;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<List<NotificationModel>>? _subscription;
  VoidCallback? _authListener;

  @override
  void onInit() {
    super.onInit();
    _authListener = () {
      unawaited(loadNotifications());
    };
    _authService.addListener(_authListener!);
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      notifications.clear();
      unreadCount.value = 0;
      _notificationService.unreadCount.value = 0;
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    _subscription?.cancel();
    _subscription = _repository.notifications(userId).listen((items) {
      notifications.assignAll(items);
      unreadCount.value = items.where((item) => !item.isRead).length;
      _notificationService.unreadCount.value = unreadCount.value;
      isLoading.value = false;
    });
  }

  Future<void> markRead(NotificationModel notification) async {
    if (notification.isRead) {
      return;
    }
    await _repository.markRead(notification.id);
  }

  Future<void> markAllRead() async {
    final unreadIds = notifications
        .where((item) => !item.isRead)
        .map((item) => item.id)
        .toList(growable: false);
    if (unreadIds.isEmpty) {
      return;
    }
    await _repository.markAllRead(unreadIds);
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    await _repository.deleteNotification(notification.id);
    await _analyticsService.logEvent(
      AnalyticsEvents.notificationDismissed,
      parameters: {'notification_type': notification.type},
    );
  }

  Future<void> openNotification(NotificationModel notification) async {
    await markRead(notification);
    await _notificationService.openNotification(notification);
  }

  @override
  void onClose() {
    if (_authListener != null) {
      _authService.removeListener(_authListener!);
    }
    _subscription?.cancel();
    super.onClose();
  }
}
