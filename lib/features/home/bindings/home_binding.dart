import 'package:get/get.dart';

import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/share_service.dart';
import '../../../data/repositories/case_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/vote_repository.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationsController>()) {
      Get.lazyPut<NotificationsController>(
        () => NotificationsController(
          repository: Get.find<NotificationRepository>(),
          authService: Get.find<AuthService>(),
          analyticsService: Get.find<AnalyticsService>(),
          notificationService: Get.find<NotificationService>(),
        ),
        fenix: true,
      );
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(
        () => HomeController(
          caseRepository: Get.find<CaseRepository>(),
          voteRepository: Get.find<VoteRepository>(),
          userRepository: Get.find<UserRepository>(),
          authService: Get.find<AuthService>(),
          analyticsService: Get.find<AnalyticsService>(),
          shareService: Get.find<ShareService>(),
        ),
        fenix: true,
      );
    }
  }
}
