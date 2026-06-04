import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../controllers/premium_controller.dart';
import '../widgets/premium_benefits_section.dart';
import '../widgets/premium_plan_card.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PremiumController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: Obx(() {
        if (!controller.isReady) {
          return const _PremiumLoading();
        }

        if (controller.monthlyPackage == null && controller.yearlyPackage == null) {
          return const EmptyState(
            title: 'Plans unavailable',
            message: 'Subscription plans are not available right now.',
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unlock Premium',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'Get advanced insights and an ad-free experience.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: AppDimensions.space24),
              if (controller.monthlyPackage != null)
                PremiumPlanCard.fromPackage(
                  package: controller.monthlyPackage!,
                  isSelected:
                      controller.selectedPackageId.value ==
                      controller.monthlyPackage!.identifier,
                  onTap: () => controller.selectPackage(controller.monthlyPackage!),
                ),
              if (controller.monthlyPackage != null &&
                  controller.yearlyPackage != null)
                const SizedBox(height: AppDimensions.space16),
              if (controller.yearlyPackage != null)
                PremiumPlanCard.fromPackage(
                  package: controller.yearlyPackage!,
                  isSelected:
                      controller.selectedPackageId.value ==
                      controller.yearlyPackage!.identifier,
                  onTap: () => controller.selectPackage(controller.yearlyPackage!),
                ),
              const SizedBox(height: AppDimensions.space24),
              const AppCard(child: PremiumBenefitsSection()),
              const SizedBox(height: AppDimensions.space24),
              if (controller.errorMessage.value.isNotEmpty) ...[
                Text(
                  controller.errorMessage.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),
              ],
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: controller.isPremium ? 'Premium Active' : 'Continue',
                  onPressed: controller.isPremium
                      ? null
                      : controller.purchaseSelected,
                  isLoading: controller.isLoading.value,
                ),
              ),
              const SizedBox(height: AppDimensions.space12),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Restore Purchases',
                  onPressed: controller.restorePurchases,
                  isLoading: controller.isRestoring.value,
                  variant: AppButtonVariant.outlined,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _PremiumLoading extends StatelessWidget {
  const _PremiumLoading();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.space16),
      children: const [
        LoadingSkeleton(height: 110),
        SizedBox(height: AppDimensions.space16),
        LoadingSkeleton(height: 110),
        SizedBox(height: AppDimensions.space24),
        LoadingSkeleton(height: 240),
      ],
    );
  }
}
