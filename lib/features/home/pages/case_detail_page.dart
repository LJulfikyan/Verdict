import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../controllers/case_detail_controller.dart';
import '../widgets/feed_card.dart';

class CaseDetailPage extends StatelessWidget {
  const CaseDetailPage({required this.caseId, super.key});

  final String caseId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaseDetailController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize(caseId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Case Detail')),
      body: Obx(() {
        switch (controller.state.value) {
          case CaseDetailState.loading:
            return const Padding(
              padding: EdgeInsets.all(AppDimensions.space16),
              child: LoadingSkeleton(height: 320),
            );
          case CaseDetailState.error:
            return ErrorState(
              title: 'Could not load case',
              message:
                  controller.errorMessage.value ??
                  'Try loading this case again.',
              onRetry: controller.loadCase,
            );
          case CaseDetailState.notFound:
            return const EmptyState(
              title: 'Case unavailable',
              message: 'This case was removed or is no longer active.',
            );
          case CaseDetailState.success:
            final item = controller.caseModel.value;
            if (item == null) {
              return const EmptyState(
                title: 'Case unavailable',
                message: 'This case was removed or is no longer active.',
              );
            }
            return ListView(
              padding: const EdgeInsets.all(AppDimensions.space16),
              children: [
                FeedCard(
                  caseModel: item,
                  isSaved: controller.isSaved.value,
                  isExpanded: controller.isExpanded.value,
                  isVoting: controller.isVoting.value,
                  pendingVoteOption: controller.pendingVoteOption.value,
                  onVote: controller.vote,
                  onSave: controller.toggleSave,
                  onShare: controller.share,
                  onToggleExpanded: controller.toggleExpanded,
                ),
                const SizedBox(height: AppDimensions.space16),
                AppButton(
                  label: 'Refresh',
                  variant: AppButtonVariant.outlined,
                  onPressed: controller.loadCase,
                ),
              ],
            );
        }
      }),
    );
  }
}
