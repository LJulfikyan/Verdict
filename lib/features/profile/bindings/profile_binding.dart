import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/premium_service.dart';
import '../../../data/repositories/user_repository.dart';
import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ProfileController>()) {
      Get.lazyPut<ProfileController>(
        () => ProfileController(
          authService: Get.find<AuthService>(),
          premiumService: Get.find<PremiumService>(),
          userRepository: Get.find<UserRepository>(),
        ),
        fenix: true,
      );
    }
  }
}
