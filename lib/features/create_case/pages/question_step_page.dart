import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/debug_logger.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../controllers/create_case_controller.dart';
import '../widgets/create_step_scaffold.dart';

class QuestionStepPage extends StatefulWidget {
  const QuestionStepPage({super.key});

  @override
  State<QuestionStepPage> createState() => _QuestionStepPageState();
}

class _QuestionStepPageState extends State<QuestionStepPage> {
  late final TextEditingController _textController;
  late final CreateCaseController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CreateCaseController>()..setStep(3);
    _textController = TextEditingController(text: _controller.question.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await _controller.submitCase();
      if (!mounted) {
        return;
      }
      DebugLogger.logNavigation(
        module: 'Router',
        className: '_QuestionStepPageState',
        method: '_submit',
        currentRoute: RouteNames.createQuestion,
        targetRoute: RouteNames.createSuccess,
      );
      context.go(RouteNames.createSuccess);
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'CreateCase',
        className: '_QuestionStepPageState',
        method: '_submit',
        error: error,
        stackTrace: stackTrace,
      );
      if (!mounted) {
        return;
      }
      final message = _controller.submissionError.value;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.isEmpty ? 'Could not submit your case.' : message,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final error = _controller.question.value.isEmpty
          ? null
          : Validators.validateQuestion(_controller.question.value);

      return CreateStepScaffold(
        step: 4,
        title: 'What do you want the verdict on?',
        subtitle:
            'Ask the final question exactly how you want people to judge it.',
        progressValue: _controller.progressValue,
        onBackPressed: () => context.go(RouteNames.createDescription),
        primaryLabel: 'Submit Case',
        isPrimaryLoading: _controller.isSubmitting.value,
        primaryEnabled: _controller.isQuestionValid.value,
        onPrimaryPressed: _submit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _textController,
              hintText: 'Was I wrong?',
              maxLength: 100,
              onChanged: _controller.setQuestion,
              errorText: error,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_controller.question.value.length}/100',
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
