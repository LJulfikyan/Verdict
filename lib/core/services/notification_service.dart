import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../firebase_options.dart';
import '../constants/analytics_events.dart';
import '../routes/route_names.dart';
import 'analytics_service.dart';
import 'auth_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class NotificationService extends GetxService {
  NotificationService({
    required FirebaseMessaging messaging,
    required AnalyticsService analyticsService,
    required AuthService authService,
    required UserRepository userRepository,
  }) : _messaging = messaging,
       _analyticsService = analyticsService,
       _authService = authService,
       _userRepository = userRepository;

  final FirebaseMessaging _messaging;
  final AnalyticsService _analyticsService;
  final AuthService _authService;
  final UserRepository _userRepository;

  final RxString _fcmToken = ''.obs;
  final RxInt unreadCount = 0.obs;
  final Rxn<RemoteMessage> lastForegroundMessage = Rxn<RemoteMessage>();

  StreamSubscription<String>? _tokenRefreshSubscription;
  VoidCallback? _authListener;
  String? _pendingRoute;

  String get fcmToken => _fcmToken.value;

  Future<NotificationService> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _messaging.requestPermission();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) {
      _fcmToken.value = token;
      unawaited(_persistToken(token));
    });

    _authListener = () {
      if (_fcmToken.value.isNotEmpty) {
        unawaited(_persistToken(_fcmToken.value));
      }
    };
    _authService.addListener(_authListener!);

    FirebaseMessaging.onMessage.listen((message) async {
      lastForegroundMessage.value = message;
      await _analyticsService.logEvent(
        AnalyticsEvents.notificationReceived,
        parameters: {'message_id': message.messageId ?? ''},
      );
      final notification = message.notification;
      if (notification != null && !Get.isSnackbarOpen) {
        Get.snackbar(
          notification.title ?? 'Notification',
          notification.body ?? '',
          snackPosition: SnackPosition.TOP,
          onTap: (_) => _handleMessageTap(message),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _analyticsService.logEvent(
        AnalyticsEvents.notificationOpened,
        parameters: {'message_id': message.messageId ?? ''},
      );
      _handleMessageTap(message);
    });

    unawaited(_loadInitialToken());

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _analyticsService.logEvent(
        AnalyticsEvents.notificationOpened,
        parameters: {'message_id': initialMessage.messageId ?? ''},
      );
      _handleMessageTap(initialMessage);
    }

    return this;
  }

  Future<void> openNotification(NotificationModel notification) async {
    await _analyticsService.logEvent(
      AnalyticsEvents.notificationOpened,
      parameters: {'notification_type': notification.type},
    );
    _navigateToRoute(
      _routeForNotificationType(notification.type, notification.targetId),
    );
  }

  void flushPendingNavigation(BuildContext context) {
    final route = _pendingRoute;
    if (route == null) {
      return;
    }
    _pendingRoute = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.go(route);
      }
    });
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
      if (_fcmToken.value.isNotEmpty) {
        await _persistToken(_fcmToken.value);
      }
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

  Future<void> _persistToken(String token) async {
    final userId = _authService.currentUser?.uid;
    if (userId == null || token.isEmpty) {
      return;
    }
    try {
      await _userRepository.updateMessagingToken(userId, token);
    } catch (error, stackTrace) {
      debugPrint('NotificationService: failed to persist token: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _handleMessageTap(RemoteMessage message) {
    _navigateToRoute(_routeForMessage(message));
  }

  void _navigateToRoute(String route) {
    final context = Get.context;
    if (context != null) {
      GoRouter.of(context).go(route);
      return;
    }
    _pendingRoute = route;
  }

  String _routeForMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type']?.toString() ?? '';
    final targetId = data['targetId']?.toString() ?? '';
    return _routeForNotificationType(type, targetId);
  }

  String _routeForNotificationType(String type, String targetId) {
    if (type == 'premium_offer') {
      return RouteNames.premium;
    }
    if (type == 'system' || type == 'moderation') {
      return RouteNames.settings;
    }
    if (targetId.isNotEmpty) {
      return RouteNames.caseDetail.replaceFirst(':caseId', targetId);
    }
    return RouteNames.inbox;
  }

  @override
  void onClose() {
    if (_authListener != null) {
      _authService.removeListener(_authListener!);
    }
    _tokenRefreshSubscription?.cancel();
    super.onClose();
  }
}
