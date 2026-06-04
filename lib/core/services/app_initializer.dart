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
import 'crashlytics_service.dart';
import 'notification_service.dart';
import 'premium_service.dart';
import 'remote_config_service.dart';
import 'share_service.dart';

class AppInitializer {
  Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final appStateService = AppStateService(preferences: preferences);
    Get.put(appStateService, permanent: true);

    await _initializeFirebase();
    _registerDataSources();
    _registerRepositories();
    await _registerServices();

    appStateService.markReady();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
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
        firestoreDataSource: Get.find<FirestoreDataSource>(),
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

    final notificationService = NotificationService(
      messaging: FirebaseMessaging.instance,
      analyticsService: analyticsService,
    );
    await notificationService.init();
    Get.put(notificationService, permanent: true);

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

    final adService = AdService(
      preferences: Get.find<AppStateService>().preferences,
    );
    await adService.init();
    Get.put(adService, permanent: true);

    Get.put(ShareService(), permanent: true);
  }
}
