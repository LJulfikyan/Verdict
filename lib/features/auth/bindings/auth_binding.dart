import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(
        () => AuthController(authService: Get.find<AuthService>()),
        fenix: true,
      );
    }
  }
}
