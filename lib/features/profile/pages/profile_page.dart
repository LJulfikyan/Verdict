import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../controllers/profile_controller.dart';
import '../widgets/premium_upgrade_banner.dart';
import '../widgets/profile_header_section.dart';
import '../widgets/profile_statistics_section.dart';
import '../widgets/saved_case_list_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        if (controller.isLoading.value && !controller.hasProfile) {
          return const _ProfileLoading();
        }

        if (controller.errorMessage.value != null && !controller.hasProfile) {
          return ErrorState(
            title: 'Could not load profile',
            message: controller.errorMessage.value!,
            onRetry: controller.refreshProfile,
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return ErrorState(
            title: 'Profile unavailable',
            message: 'Sign in to view your profile.',
            onRetry: controller.refreshProfile,
          );
        }

        final statistics = controller.statistics.value;

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.space16),
            children: [
              ProfileHeaderSection(
                profile: profile,
                isPremium: controller.isPremium,
              ),
              const SizedBox(height: AppDimensions.space24),
              if (statistics != null) ...[
                ProfileStatisticsSection(statistics: statistics),
                const SizedBox(height: AppDimensions.space24),
              ],
              _SavedCasesSection(controller: controller),
              const SizedBox(height: AppDimensions.space24),
              if (!controller.isPremium) ...[
                PremiumUpgradeBanner(
                  onTap: () async {
                    await controller.trackPremiumBannerClicked();
                    if (context.mounted) {
                      context.push(RouteNames.premium);
                    }
                  },
                ),
                const SizedBox(height: AppDimensions.space24),
              ],
              AppCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  onTap: () => context.push(RouteNames.settings),
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SavedCasesSection extends StatelessWidget {
  const _SavedCasesSection({required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Saved Cases',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await controller.trackSavedCasesOpened();
                if (context.mounted) {
                  context.push(RouteNames.profileSaved);
                }
              },
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space12),
        if (controller.isLoadingSavedCases.value && !controller.hasSavedCases)
          const Column(
            children: [
              LoadingSkeleton(height: 160),
              SizedBox(height: AppDimensions.space12),
              LoadingSkeleton(height: 160),
            ],
          )
        else if (controller.savedCasesError.value != null &&
            !controller.hasSavedCases)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Could not load saved cases',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  controller.savedCasesError.value!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )
        else if (!controller.hasSavedCases)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No saved cases yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  'Cases you save from the feed appear here.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          )
        else
          Builder(
            builder: (context) {
              final previewItems = controller.savedCases.take(3).toList();
              return Column(
                children: [
                  for (final item in previewItems) ...[
                    SavedCaseListItem(caseModel: item),
                    if (item != previewItems.last)
                      const SizedBox(height: AppDimensions.space12),
                  ],
                ],
              );
            },
          ),
      ],
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      children: const [
        LoadingSkeleton(height: 112),
        SizedBox(height: AppDimensions.space24),
        LoadingSkeleton(height: 220),
        SizedBox(height: AppDimensions.space24),
        LoadingSkeleton(height: 160),
      ],
    );
  }
}
