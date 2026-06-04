import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_section_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.space16),
            children: const [
              LoadingSkeleton(height: 180),
              SizedBox(height: AppDimensions.space16),
              LoadingSkeleton(height: 220),
              SizedBox(height: AppDimensions.space16),
              LoadingSkeleton(height: 180),
            ],
          );
        }

        if (controller.errorMessage.value != null &&
            controller.appVersion.value.isEmpty) {
          return ErrorState(
            title: 'Could not load settings',
            message: controller.errorMessage.value!,
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          children: [
            if (controller.errorMessage.value != null) ...[
              Text(
                controller.errorMessage.value!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
            ],
            SettingsSectionCard(
              title: 'Account',
              children: [
                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: const Text('Logout'),
                  onTap: controller.logout,
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('App Version'),
                  trailing: Text(controller.appVersion.value),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),
            SettingsSectionCard(
              title: 'Notifications',
              children: [
                SwitchListTile(
                  value: controller.notificationsEnabled.value,
                  onChanged: (value) =>
                      controller.notificationsEnabled.value = value,
                  title: const Text('Notifications'),
                ),
                SwitchListTile(
                  value: controller.caseActivityEnabled.value,
                  onChanged: (value) =>
                      controller.caseActivityEnabled.value = value,
                  title: const Text('Case Activity'),
                ),
                SwitchListTile(
                  value: controller.trendingEnabled.value,
                  onChanged: (value) =>
                      controller.trendingEnabled.value = value,
                  title: const Text('Trending Alerts'),
                ),
                SwitchListTile(
                  value: controller.premiumOffersEnabled.value,
                  onChanged: (value) =>
                      controller.premiumOffersEnabled.value = value,
                  title: const Text('Premium Offers'),
                ),
                SwitchListTile(
                  value: controller.systemEnabled.value,
                  onChanged: (value) => controller.systemEnabled.value = value,
                  title: const Text('System Updates'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),
            SettingsSectionCard(
              title: 'Appearance',
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Theme'),
                  subtitle: const Text('Placeholder destination'),
                  onTap: () => _showPlaceholder(context, 'Appearance'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),
            SettingsSectionCard(
              title: 'Privacy',
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  subtitle: const Text('Placeholder destination'),
                  onTap: () => _showPlaceholder(context, 'Privacy Policy'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),
            SettingsSectionCard(
              title: 'Legal',
              children: [
                ListTile(
                  leading: const Icon(Icons.gavel_outlined),
                  title: const Text('Terms of Service'),
                  subtitle: const Text('Placeholder destination'),
                  onTap: () => _showPlaceholder(context, 'Terms of Service'),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space24),
            SettingsSectionCard(
              title: 'Danger Zone',
              children: [
                ListTile(
                  leading: Icon(
                    Icons.delete_outline_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  subtitle: const Text('Placeholder action'),
                  onTap: () => _showPlaceholder(context, 'Delete Account'),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppDimensions.space12),
            Text(
              'This destination is reserved for the next implementation pass.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimensions.space16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
