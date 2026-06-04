import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/debug_logger.dart';

class SettingsController extends GetxController {
  SettingsController({
    required AuthService authService,
    required AnalyticsService analyticsService,
  }) : _authService = authService,
       _analyticsService = analyticsService;

  final AuthService _authService;
  final AnalyticsService _analyticsService;

  final RxBool notificationsEnabled = true.obs;
  final RxBool caseActivityEnabled = true.obs;
  final RxBool trendingEnabled = true.obs;
  final RxBool premiumOffersEnabled = true.obs;
  final RxBool systemEnabled = true.obs;
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();
  final RxString appVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = '${packageInfo.version} (${packageInfo.buildNumber})';
      await _analyticsService.logEvent(AnalyticsEvents.settingsOpened);
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Settings',
        className: 'SettingsController',
        method: '_initialize',
        error: error,
        stackTrace: stackTrace,
      );
      appVersion.value = '1.0.0+1';
      errorMessage.value = 'Could not load full settings metadata.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _analyticsService.logEvent(AnalyticsEvents.logout);
    await _authService.logout();
  }
}
