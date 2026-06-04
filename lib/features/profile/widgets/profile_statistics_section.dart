import 'package:flutter/material.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/profile_statistics_model.dart';

class ProfileStatisticsSection extends StatelessWidget {
  const ProfileStatisticsSection({required this.statistics, super.key});

  final ProfileStatisticsModel statistics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppDimensions.space12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppDimensions.space12,
          mainAxisSpacing: AppDimensions.space12,
          childAspectRatio: 1.45,
          children: [
            _StatCard(label: 'Cases Posted', value: statistics.casesPosted),
            _StatCard(label: 'Votes Received', value: statistics.votesReceived),
            _StatCard(label: 'Saved Cases', value: statistics.savedCasesCount),
            _StatCard(
              label: 'Agreement Score',
              value: '${statistics.agreementScore}%',
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final Object value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value.toString(),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
