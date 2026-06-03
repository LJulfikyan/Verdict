import 'package:get/get.dart';

import '../controllers/moderation_controller.dart';

class ModerationBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ModerationController>()) {
      Get.lazyPut<ModerationController>(ModerationController.new, fenix: true);
    }
  }
}
