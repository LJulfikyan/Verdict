import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../controllers/profile_controller.dart';
import '../widgets/saved_case_list_item.dart';

class SavedCasesPage extends StatelessWidget {
  const SavedCasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasSavedCases && !controller.isLoadingSavedCases.value) {
        controller.loadSavedCases(reset: true);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Cases')),
      body: Obx(() {
        if (controller.isLoadingSavedCases.value && !controller.hasSavedCases) {
          return const _SavedCasesLoading();
        }

        if (controller.savedCasesError.value != null &&
            !controller.hasSavedCases) {
          return ErrorState(
            title: 'Could not load saved cases',
            message: controller.savedCasesError.value!,
            onRetry: () => controller.loadSavedCases(reset: true),
          );
        }

        if (!controller.hasSavedCases) {
          return const EmptyState(
            title: 'No saved cases',
            message: 'Saved cases from the feed appear here.',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshProfile,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 300) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.space16),
              itemCount:
                  controller.savedCases.length +
                  (controller.hasMore.value ? 1 : 0),
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppDimensions.space12),
              itemBuilder: (context, index) {
                if (index >= controller.savedCases.length) {
                  return const Padding(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final item = controller.savedCases[index];
                return SavedCaseListItem(
                  caseModel: item,
                  onTap: () => context.push(
                    RouteNames.caseDetail.replaceFirst(':caseId', item.id),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _SavedCasesLoading extends StatelessWidget {
  const _SavedCasesLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.space16),
      itemBuilder: (context, index) => const LoadingSkeleton(height: 160),
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppDimensions.space12),
      itemCount: 5,
    );
  }
}
