import 'package:get/get.dart';

import '../../../core/services/app_state_service.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OnboardingController>()) {
      Get.lazyPut<OnboardingController>(
        () =>
            OnboardingController(appStateService: Get.find<AppStateService>()),
        fenix: true,
      );
    }
  }
}
