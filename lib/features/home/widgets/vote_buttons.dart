import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';

class VoteButtons extends StatelessWidget {
  const VoteButtons({
    required this.selectedVote,
    required this.isLoading,
    required this.pendingVoteOption,
    required this.onVote,
    super.key,
  });

  final String? selectedVote;
  final bool isLoading;
  final String? pendingVoteOption;
  final ValueChanged<String> onVote;

  static const _options = <(String, String)>[
    ('youRight', 'You\'re Right'),
    ('theyRight', 'They\'re Right'),
    ('bothWrong', 'Both Wrong'),
    ('needInfo', 'Need More Info'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasVoted = selectedVote != null;

    return Wrap(
      spacing: AppDimensions.space8,
      runSpacing: AppDimensions.space8,
      children: _options
          .map((option) {
            final isSelected =
                selectedVote == option.$1 || pendingVoteOption == option.$1;

            return SizedBox(
              width: (MediaQuery.sizeOf(context).width - 72) / 2,
              height: 52,
              child: OutlinedButton(
                onPressed: hasVoted || isLoading
                    ? null
                    : () => onVote(option.$1),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surface,
                  side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading && pendingVoteOption == option.$1
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        option.$2,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
