import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';

class PremiumBenefitsSection extends StatelessWidget {
  const PremiumBenefitsSection({super.key});

  static const _benefits = <String>[
    'No ads',
    'Advanced demographics',
    'Relationship insights',
    'Early access features',
    'Custom themes',
    'Priority support',
    'Premium badge',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium benefits',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.space16),
        ..._benefits.map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space12),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Text(
                    benefit,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
