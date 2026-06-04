import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/premium_service.dart';
import '../../../data/repositories/user_repository.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(
        () => ProfileController(
          authService: Get.find<AuthService>(),
          analyticsService: Get.find<AnalyticsService>(),
          premiumService: Get.find<PremiumService>(),
          userRepository: Get.find<UserRepository>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<EditProfileController>()) {
      Get.lazyPut<EditProfileController>(
        () => EditProfileController(
          authService: Get.find<AuthService>(),
          analyticsService: Get.find<AnalyticsService>(),
          userRepository: Get.find<UserRepository>(),
        ),
        fenix: true,
      );
    }
  }
}
