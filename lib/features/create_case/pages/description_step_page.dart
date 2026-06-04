import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/create_case_controller.dart';
import '../widgets/create_step_scaffold.dart';

class DescriptionStepPage extends StatefulWidget {
  const DescriptionStepPage({super.key});

  @override
  State<DescriptionStepPage> createState() => _DescriptionStepPageState();
}

class _DescriptionStepPageState extends State<DescriptionStepPage> {
  late final TextEditingController _textController;
  late final CreateCaseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CreateCaseController>()..setStep(2);
    _textController = TextEditingController(
      text: _controller.description.value,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final error = _controller.description.value.isEmpty
          ? null
          : Validators.validateCaseDescription(_controller.description.value);

      return CreateStepScaffold(
        step: 3,
        title: 'Describe the conflict',
        subtitle:
            'Share the situation clearly. Minimum 50 characters, maximum 500.',
        progressValue: _controller.progressValue,
        onBackPressed: () => context.go(RouteNames.createCategory),
        primaryLabel: 'Next',
        primaryEnabled: _controller.isDescriptionValid.value,
        onPrimaryPressed: () {
          _controller.nextStep();
          context.go(RouteNames.createQuestion);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _textController,
              hintText: 'Explain what happened...',
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              maxLength: 500,
              onChanged: _controller.setDescription,
              errorText: error,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_controller.description.value.length}/500',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: error == null
                      ? AppColors.textSecondary
                      : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
