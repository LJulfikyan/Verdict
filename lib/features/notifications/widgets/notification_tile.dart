import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../data/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
        color: theme.colorScheme.error,
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space8,
        ),
        leading: Badge(
          isLabelVisible: !notification.isRead,
          smallSize: 10,
          child: CircleAvatar(child: Icon(_iconForType(notification.type))),
        ),
        title: Text(
          notification.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppDimensions.space4),
          child: Text(notification.body),
        ),
        trailing: Text(
          AppDateUtils.formatRelative(notification.createdAt ?? DateTime.now()),
          style: theme.textTheme.bodySmall,
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'case_milestone':
      case 'case_trending':
        return Icons.local_fire_department_outlined;
      case 'premium_offer':
        return Icons.workspace_premium_outlined;
      case 'moderation':
        return Icons.gavel_outlined;
      case 'system':
        return Icons.settings_outlined;
      case 'daily_engagement':
      default:
        return Icons.notifications_outlined;
    }
  }
}
