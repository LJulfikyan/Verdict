import 'package:get/get.dart';

import '../../../core/services/analytics_service.dart';
import '../../../data/repositories/case_repository.dart';
import '../controllers/create_case_controller.dart';

class CreateCaseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CreateCaseController>()) {
      Get.lazyPut<CreateCaseController>(
        () => CreateCaseController(
          caseRepository: Get.find<CaseRepository>(),
          analyticsService: Get.find<AnalyticsService>(),
        ),
        fenix: true,
      );
    }
  }
}
