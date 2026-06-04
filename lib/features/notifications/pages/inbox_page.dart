import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/empty_state.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_tile.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          Obx(() {
            final hasUnread = controller.unreadCount.value > 0;
            return TextButton(
              onPressed: hasUnread ? controller.markAllRead : null,
              child: const Text('Mark all read'),
            );
          }),
          const SizedBox(width: AppDimensions.space8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const EmptyState(
            title: 'No notifications',
            message: 'You are all caught up.',
          );
        }

        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return NotificationTile(
              notification: notification,
              onTap: () => controller.openNotification(notification),
              onDelete: () => controller.deleteNotification(notification),
            );
          },
        );
      }),
    );
  }
}
