import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class CreateStepScaffold extends StatelessWidget {
  const CreateStepScaffold({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.progressValue,
    required this.child,
    this.primaryLabel,
    this.onPrimaryPressed,
    this.onBackPressed,
    this.isPrimaryLoading = false,
    this.primaryEnabled = true,
    super.key,
  });

  final int step;
  final String title;
  final String subtitle;
  final double progressValue;
  final Widget child;
  final String? primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onBackPressed;
  final bool isPrimaryLoading;
  final bool primaryEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space16,
                AppDimensions.space12,
                AppDimensions.space16,
                AppDimensions.space8,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBackPressed,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progressValue,
                        backgroundColor: AppColors.primaryContainer,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space12),
                  Text(
                    '$step/4',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.space24,
                  AppDimensions.space16,
                  AppDimensions.space24,
                  AppDimensions.space24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space32),
                    child,
                  ],
                ),
              ),
            ),
            if (primaryLabel != null)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.space24,
                    AppDimensions.space12,
                    AppDimensions.space24,
                    AppDimensions.space24,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight,
                    child: FilledButton(
                      onPressed: primaryEnabled && !isPrimaryLoading
                          ? onPrimaryPressed
                          : null,
                      child: isPrimaryLoading
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(primaryLabel!),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
