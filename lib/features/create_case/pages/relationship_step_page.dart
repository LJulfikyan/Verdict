import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../controllers/create_case_controller.dart';
import '../widgets/create_step_scaffold.dart';
import '../widgets/relationship_option_card.dart';

class RelationshipStepPage extends StatelessWidget {
  const RelationshipStepPage({super.key});

  static const _options = [
    'Wife',
    'Girlfriend',
    'Fiancée',
    'Boyfriend',
    'Husband',
    'Partner',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateCaseController>()..setStep(0);

    return Obx(
      () => CreateStepScaffold(
        step: 1,
        title: 'Who is this about?',
        subtitle: 'Choose the relationship type for your case.',
        progressValue: controller.progressValue,
        onBackPressed: () => context.go(RouteNames.home),
        primaryLabel: 'Next',
        primaryEnabled: controller.isRelationshipValid.value,
        onPrimaryPressed: () {
          controller.nextStep();
          context.go(RouteNames.createCategory);
        },
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: 80,
          ),
          itemBuilder: (context, index) {
            final option = _options[index];
            return RelationshipOptionCard(
              label: option,
              isSelected: controller.relationshipType.value == option,
              onTap: () => controller.setRelationshipType(option),
            );
          },
        ),
      ),
    );
  }
}
