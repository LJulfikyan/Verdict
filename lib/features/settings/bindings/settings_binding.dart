import 'package:get/get.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<SettingsController>()) {
      return;
    }
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        authService: Get.find<AuthService>(),
        analyticsService: Get.find<AnalyticsService>(),
      ),
      fenix: true,
    );
  }
}
