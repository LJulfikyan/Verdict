import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../constants/analytics_events.dart';
import 'analytics_service.dart';

class NotificationService extends GetxService {
  NotificationService({
    required FirebaseMessaging messaging,
    required AnalyticsService analyticsService,
  }) : _messaging = messaging,
       _analyticsService = analyticsService;

  final FirebaseMessaging _messaging;
  final AnalyticsService _analyticsService;

  final RxString _fcmToken = ''.obs;

  String get fcmToken => _fcmToken.value;

  Future<NotificationService> init() async {
    await _messaging.requestPermission();
    _fcmToken.value = await _messaging.getToken() ?? '';

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _analyticsService.logEvent(
        AnalyticsEvents.notificationOpened,
        parameters: {'message_id': message.messageId ?? ''},
      );
    });

    return this;
  }
}
