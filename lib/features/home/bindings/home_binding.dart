import 'package:get/get.dart';

import '../../../core/services/share_service.dart';
import '../controllers/home_controller.dart';
import '../repositories/home_mock_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeMockRepository>()) {
      Get.put(HomeMockRepository(), permanent: true);
    }

    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(
        () => HomeController(
          repository: Get.find<HomeMockRepository>(),
          shareService: Get.find<ShareService>(),
        ),
        fenix: true,
      );
    }
  }
}
