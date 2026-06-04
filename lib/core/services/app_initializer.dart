import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/datasources/firestore_datasource.dart';
import '../../data/datasources/functions_datasource.dart';
import '../../data/datasources/notification_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/case_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/premium_repository.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/vote_repository.dart';
import '../../firebase_options.dart';
import '../constants/app_constants.dart';
import 'ad_service.dart';
import 'analytics_service.dart';
import 'app_state_service.dart';
import 'auth_service.dart';
import 'case_action_service.dart';
import 'crashlytics_service.dart';
import 'debug_logger.dart';
import 'notification_service.dart';
import 'premium_service.dart';
import 'remote_config_service.dart';
import 'share_service.dart';

class AppInitializer {
  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: 'initialize',
      message: 'App initialization started',
      additionalDetails: {
        'platform': Platform.operatingSystem,
        'isProduction': AppConstants.isProduction,
        'revenueCatAndroidKeySet':
            AppConstants.revenueCatAndroidApiKey.isNotEmpty,
        'revenueCatIosKeySet': AppConstants.revenueCatIosApiKey.isNotEmpty,
        'admobAndroidAppIdSet': AppConstants.admobAndroidAppId.isNotEmpty,
        'admobIosAppIdSet': AppConstants.admobIosAppId.isNotEmpty,
        'googleWebClientIdSet': AppConstants.googleWebClientId.isNotEmpty,
        'googleServerClientIdSet': AppConstants.googleServerClientId.isNotEmpty,
      },
    );
    final appStateService = AppStateService(preferences: preferences);
    Get.put(appStateService, permanent: true);

    await _initializeFirebase();
    _registerDataSources();
    _registerRepositories();
    await _registerServices();

    appStateService.markReady();
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: 'initialize',
      message: 'App initialization completed',
    );
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: '_initializeFirebase',
      message: 'Firebase initialized',
      additionalDetails: {
        'projectId': Firebase.app().options.projectId,
        'appId': Firebase.app().options.appId,
      },
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: '_initializeFirebase',
      message: 'Firestore persistence enabled',
      additionalDetails: {'persistenceEnabled': true},
    );
  }

  void _registerDataSources() {
    Get.put(
      FirebaseAuthDataSource(firebaseAuth: FirebaseAuth.instance),
      permanent: true,
    );
    Get.put(
      FirestoreDataSource(firestore: FirebaseFirestore.instance),
      permanent: true,
    );
    Get.put(
      FunctionsDataSource(
        functions: FirebaseFunctions.instanceFor(region: 'us-central1'),
      ),
      permanent: true,
    );
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: '_registerDataSources',
      message: 'Functions initialized',
      additionalDetails: {'region': 'us-central1'},
    );
    Get.put(
      NotificationDataSource(
        firestoreDataSource: Get.find<FirestoreDataSource>(),
      ),
      permanent: true,
    );
  }

  void _registerRepositories() {
    Get.put(
      AuthRepository(dataSource: Get.find<FirebaseAuthDataSource>()),
      permanent: true,
    );
    Get.put(
      CaseRepository(
        authDataSource: Get.find<FirebaseAuthDataSource>(),
        firestoreDataSource: Get.find<FirestoreDataSource>(),
        functionsDataSource: Get.find<FunctionsDataSource>(),
      ),
      permanent: true,
    );
    Get.put(
      UserRepository(firestoreDataSource: Get.find<FirestoreDataSource>()),
      permanent: true,
    );
    Get.put(
      VoteRepository(
        firestoreDataSource: Get.find<FirestoreDataSource>(),
        functionsDataSource: Get.find<FunctionsDataSource>(),
      ),
      permanent: true,
    );
    Get.put(
      ReportRepository(
        firestoreDataSource: Get.find<FirestoreDataSource>(),
        functionsDataSource: Get.find<FunctionsDataSource>(),
      ),
      permanent: true,
    );
    Get.put(
      NotificationRepository(
        authDataSource: Get.find<FirebaseAuthDataSource>(),
        notificationDataSource: Get.find<NotificationDataSource>(),
        functionsDataSource: Get.find<FunctionsDataSource>(),
      ),
      permanent: true,
    );
    Get.put(PremiumRepository(), permanent: true);
  }

  Future<void> _registerServices() async {
    final analyticsService = AnalyticsService(
      analytics: FirebaseAnalytics.instance,
    );
    await analyticsService.init();
    Get.put(analyticsService, permanent: true);

    final crashlyticsService = CrashlyticsService(
      crashlytics: FirebaseCrashlytics.instance,
    );
    await crashlyticsService.init();
    Get.put(crashlyticsService, permanent: true);

    final remoteConfigService = RemoteConfigService(
      remoteConfig: FirebaseRemoteConfig.instance,
    );
    await remoteConfigService.init();
    Get.put(remoteConfigService, permanent: true);

    final authService = AuthService(
      repository: Get.find<AuthRepository>(),
      userRepository: Get.find<UserRepository>(),
    );
    await authService.init();
    Get.put(authService, permanent: true);
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: '_registerServices',
      message: 'Auth service initialized',
      additionalDetails: {
        'currentUser': authService.currentUser?.uid,
        'isGuest': authService.isGuest,
      },
    );

    final notificationService = NotificationService(
      messaging: FirebaseMessaging.instance,
      analyticsService: analyticsService,
      authService: authService,
      userRepository: Get.find<UserRepository>(),
    );
    await notificationService.init();
    Get.put(notificationService, permanent: true);
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: '_registerServices',
      message: 'Notification service initialized',
      additionalDetails: {'fcmToken': notificationService.fcmToken},
    );

    final premiumService = PremiumService(
      repository: Get.find<PremiumRepository>(),
      analyticsService: analyticsService,
    );
    await premiumService.init(
      apiKey: Platform.isIOS
          ? AppConstants.revenueCatIosApiKey
          : AppConstants.revenueCatAndroidApiKey,
    );
    Get.put(premiumService, permanent: true);
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: '_registerServices',
      message: 'RevenueCat initialized',
      additionalDetails: {'isReady': premiumService.isReady},
    );

    final adService = AdService(
      preferences: Get.find<AppStateService>().preferences,
    );
    await adService.init();
    Get.put(adService, permanent: true);
    DebugLogger.logInfo(
      module: 'Startup',
      className: 'AppInitializer',
      method: '_registerServices',
      message: 'AdMob initialized',
      additionalDetails: {'isConfigured': adService.isConfigured.value},
    );

    Get.put(ShareService(), permanent: true);
    Get.put(
      CaseActionService(
        caseRepository: Get.find<CaseRepository>(),
        voteRepository: Get.find<VoteRepository>(),
        analyticsService: analyticsService,
        shareService: Get.find<ShareService>(),
      ),
      permanent: true,
    );
  }
}
