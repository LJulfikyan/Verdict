import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/case_model.dart';
import 'results_bars.dart';
import 'save_button.dart';
import 'share_button.dart';
import 'vote_buttons.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({
    required this.caseModel,
    required this.isSaved,
    required this.isExpanded,
    required this.isVoting,
    required this.onVote,
    required this.onSave,
    required this.onShare,
    required this.onToggleExpanded,
    super.key,
  });

  final CaseModel caseModel;
  final bool isSaved;
  final bool isExpanded;
  final bool isVoting;
  final ValueChanged<String> onVote;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showExpandedToggle = caseModel.description.length > 150;
    final previewText = isExpanded || !showExpandedToggle
        ? caseModel.description
        : '${caseModel.description.substring(0, 150).trim()}...';
    final hasVoted = caseModel.userVote != null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8,
                  vertical: AppDimensions.space4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  caseModel.relationshipType,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                AppDateUtils.formatRelative(
                  caseModel.createdAt ?? DateTime.now(),
                ),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(
            previewText,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              height: 1.55,
            ),
          ),
          if (showExpandedToggle) ...[
            const SizedBox(height: AppDimensions.space8),
            TextButton(
              onPressed: onToggleExpanded,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(isExpanded ? 'Show less' : 'Show more'),
            ),
          ],
          const SizedBox(height: AppDimensions.space12),
          Text(
            caseModel.question,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          VoteButtons(
            selectedVote: caseModel.userVote,
            isLoading: isVoting,
            onVote: onVote,
          ),
          if (hasVoted) ...[
            const SizedBox(height: AppDimensions.space16),
            ResultsBars(
              results: caseModel.results,
              selectedVote: caseModel.userVote,
            ),
          ],
          const SizedBox(height: AppDimensions.space8),
          Row(
            children: [
              Text(
                '${caseModel.votesCount} votes',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              SaveButton(isSaved: isSaved, onPressed: onSave),
              ShareButton(onPressed: onShare),
            ],
          ),
        ],
      ),
    );
  }
}
