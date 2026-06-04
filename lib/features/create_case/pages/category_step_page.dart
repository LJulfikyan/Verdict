import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/create_case_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/create_step_scaffold.dart';

class CategoryStepPage extends StatelessWidget {
  const CategoryStepPage({super.key});

  static const _options = [
    'Money',
    'Jealousy',
    'Family',
    'Friends',
    'Travel',
    'Children',
    'Social Media',
    'Communication',
    'Household',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCaseController>()..setStep(1);

    return Obx(
      () => CreateStepScaffold(
        step: 2,
        title: 'What category fits best?',
        subtitle: 'Pick the closest match for your disagreement.',
        progressValue: controller.progressValue,
        onBackPressed: () => context.go(RouteNames.createRelationship),
        primaryLabel: 'Next',
        primaryEnabled: controller.isCategoryValid.value,
        onPrimaryPressed: () {
          controller.nextStep();
          context.go(RouteNames.createDescription);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _options
                  .map(
                    (option) => CategoryChip(
                      label: option,
                      isSelected: controller.category.value == option,
                      onTap: () => controller.setCategory(option),
                    ),
                  )
                  .toList(growable: false),
            ),
            if (!controller.isCategoryValid.value)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Please choose a category.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
