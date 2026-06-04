import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../onboarding/widgets/app_logo_mark.dart';
import '../controllers/home_controller.dart';
import '../widgets/feed_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: const AppLogoMark(size: 28, showWordmark: false),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: AppDimensions.space8),
        ],
      ),
      body: Obx(() {
        if (controller.feedState.value == FeedState.loading &&
            controller.feedItems.isEmpty) {
          return const _HomeFeedLoading();
        }

        if (controller.feedState.value == FeedState.empty) {
          return const EmptyState(
            title: 'No cases yet',
            message: 'New relationship cases will appear here.',
          );
        }

        if (controller.feedState.value == FeedState.error) {
          return EmptyState(
            title: 'Could not load feed',
            message: 'Pull to refresh and try again.',
            action: FilledButton(
              onPressed: controller.loadFeed,
              child: const Text('Retry'),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshFeed,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 400) {
                controller.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                top: AppDimensions.space8,
                bottom: AppDimensions.space24,
              ),
              itemCount:
                  controller.feedItems.length +
                  (controller.hasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= controller.feedItems.length) {
                  return const Padding(
                    padding: EdgeInsets.all(AppDimensions.space16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final item = controller.feedItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.space16,
                    vertical: AppDimensions.space8,
                  ),
                  child: Align(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.85,
                      ),
                      child: FeedCard(
                        caseModel: item,
                        isSaved: controller.isSaved(item.id),
                        isExpanded: controller.isExpanded(item.id),
                        isVoting: controller.isVoteBusy(item.id),
                        pendingVoteOption: controller.pendingVoteOption(item.id),
                        onVote: (option) => controller.vote(item, option),
                        onSave: () => controller.toggleSaveCase(item),
                        onShare: () => controller.shareCase(item),
                        onToggleExpanded: () =>
                            controller.toggleExpanded(item.id),
                      ),
                    ),
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

class _HomeFeedLoading extends StatelessWidget {
  const _HomeFeedLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.space16),
      itemBuilder: (context, index) => Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.85,
          ),
          child: const LoadingSkeleton(height: 320),
        ),
      ),
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppDimensions.space16),
      itemCount: 4,
    );
  }
}
