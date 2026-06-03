import 'package:get/get.dart';

import '../../../core/services/premium_service.dart';
import '../controllers/premium_controller.dart';

class PremiumBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PremiumController>()) {
      Get.lazyPut<PremiumController>(
        () => PremiumController(premiumService: Get.find<PremiumService>()),
        fenix: true,
      );
    }
  }
}
