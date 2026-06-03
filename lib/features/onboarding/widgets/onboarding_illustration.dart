import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../models/onboarding_item.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({required this.type, super.key});

  final OnboardingIllustrationType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case OnboardingIllustrationType.cards:
        return const _VotingCardsIllustration();
      case OnboardingIllustrationType.anonymous:
        return const _AnonymousIllustration();
      case OnboardingIllustrationType.chart:
        return const _ChartIllustration();
    }
  }
}

class _VotingCardsIllustration extends StatelessWidget {
  const _VotingCardsIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: const [
          _TiltedCard(
            angle: -0.12,
            offset: Offset(-42, 18),
            label: 'You\'re Right',
            tone: AppColors.primaryContainer,
          ),
          _TiltedCard(
            angle: 0.09,
            offset: Offset(44, 26),
            label: 'Need More Info',
            tone: Color(0xFFF3F4F6),
          ),
          _TiltedCard(
            angle: -0.02,
            offset: Offset(0, -8),
            label: 'They\'re Right',
            tone: Colors.white,
            elevated: true,
          ),
        ],
      ),
    );
  }
}

class _AnonymousIllustration extends StatelessWidget {
  const _AnonymousIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            top: 28,
            child: Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
          Positioned(
            bottom: 22,
            child: Container(
              width: 212,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(color: AppColors.outline),
              ),
              child: const Column(
                children: [
                  _FakeLine(widthFactor: 0.72),
                  SizedBox(height: 10),
                  _FakeLine(widthFactor: 0.88),
                  SizedBox(height: 10),
                  _FakeLine(widthFactor: 0.54),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartIllustration extends StatelessWidget {
  const _ChartIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          _Bar(height: 76, color: Color(0xFFD9CCFF)),
          SizedBox(width: 16),
          _Bar(height: 118, color: Color(0xFFB396FF)),
          SizedBox(width: 16),
          _Bar(height: 158, color: AppColors.primary),
          SizedBox(width: 16),
          _Bar(height: 102, color: Color(0xFFD9CCFF)),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.color});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class _TiltedCard extends StatelessWidget {
  const _TiltedCard({
    required this.angle,
    required this.offset,
    required this.label,
    required this.tone,
    this.elevated = false,
  });

  final double angle;
  final Offset offset;
  final String label;
  final Color tone;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: tone,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: AppColors.outline),
            boxShadow: elevated
                ? [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                      color: Colors.black.withValues(alpha: 0.08),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              const _FakeLine(widthFactor: 0.9),
              const SizedBox(height: 8),
              const _FakeLine(widthFactor: 0.68),
            ],
          ),
        ),
      ),
    );
  }
}

class _FakeLine extends StatelessWidget {
  const _FakeLine({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
