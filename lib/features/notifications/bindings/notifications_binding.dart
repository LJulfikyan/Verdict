import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/repositories/notification_repository.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<NotificationsController>()) {
      Get.lazyPut<NotificationsController>(
        () => NotificationsController(
          repository: Get.find<NotificationRepository>(),
          authService: Get.find<AuthService>(),
        ),
        fenix: true,
      );
    }
  }
}
