import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
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
  StreamSubscription<String>? _tokenRefreshSubscription;

  String get fcmToken => _fcmToken.value;

  Future<NotificationService> init() async {
    await _messaging.requestPermission();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) {
      _fcmToken.value = token;
    });

    unawaited(_loadInitialToken());

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _analyticsService.logEvent(
        AnalyticsEvents.notificationOpened,
        parameters: {'message_id': message.messageId ?? ''},
      );
    });

    return this;
  }

  Future<void> _loadInitialToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _waitForApnsToken();
        if (apnsToken == null || apnsToken.isEmpty) {
          debugPrint(
            'NotificationService: APNS token not available yet; '
            'skipping initial FCM token fetch.',
          );
          return;
        }
      }

      _fcmToken.value = await _messaging.getToken() ?? '';
    } catch (error, stackTrace) {
      debugPrint(
        'NotificationService: failed to fetch initial FCM token: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<String?> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 10; attempt++) {
      final token = await _messaging.getAPNSToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return null;
  }

  @override
  void onClose() {
    _tokenRefreshSubscription?.cancel();
    super.onClose();
  }
}
