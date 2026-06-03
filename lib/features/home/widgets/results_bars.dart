import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class ResultsBars extends StatelessWidget {
  const ResultsBars({
    required this.results,
    required this.selectedVote,
    super.key,
  });

  final Map<String, int> results;
  final String? selectedVote;

  static const _labels = <String, String>{
    'youRight': 'You\'re Right',
    'theyRight': 'They\'re Right',
    'bothWrong': 'Both Wrong',
    'needInfo': 'Need More Info',
  };

  @override
  Widget build(BuildContext context) {
    final total = results.values.fold<int>(0, (sum, value) => sum + value);

    return Column(
      children: _labels.entries
          .map((entry) {
            final value = results[entry.key] ?? 0;
            final ratio = total == 0 ? 0.0 : value / total;
            final isSelected = selectedVote == entry.key;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.space8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.value,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                        ),
                      ),
                      Text(
                        '${(ratio * 100).round()}%',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: ratio,
                      backgroundColor: AppColors.primaryContainer,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isSelected ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
