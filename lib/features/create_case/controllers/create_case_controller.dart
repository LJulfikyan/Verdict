import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/case_repository.dart';
import '../../../core/services/analytics_service.dart';

class CreateCaseController extends GetxController {
  CreateCaseController({
    required CaseRepository caseRepository,
    required AnalyticsService analyticsService,
  }) : _caseRepository = caseRepository,
       _analyticsService = analyticsService;

  final CaseRepository _caseRepository;
  final AnalyticsService _analyticsService;

  final RxInt currentStep = 0.obs;
  final RxString relationshipType = ''.obs;
  final RxString category = ''.obs;
  final RxString description = ''.obs;
  final RxString question = ''.obs;
  final RxBool isSubmitting = false.obs;

  final RxBool isRelationshipValid = false.obs;
  final RxBool isCategoryValid = false.obs;
  final RxBool isDescriptionValid = false.obs;
  final RxBool isQuestionValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _analyticsService.logEvent(AnalyticsEvents.caseCreateStarted);
  }

  void nextStep() {
    validateStep();
    if (_isCurrentStepValid) {
      currentStep.value += 1;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value -= 1;
    }
  }

  void validateStep() {
    isRelationshipValid.value = relationshipType.value.isNotEmpty;
    isCategoryValid.value = category.value.isNotEmpty;
    isDescriptionValid.value =
        Validators.validateCaseDescription(description.value) == null;
    isQuestionValid.value = Validators.validateQuestion(question.value) == null;
  }

  Future<String> submitCase() async {
    validateStep();
    if (!_isAllValid) {
      throw StateError('Create case data is invalid.');
    }
    isSubmitting.value = true;
    try {
      final caseId = await _caseRepository.createCase(
        relationshipType: relationshipType.value,
        category: category.value,
        description: description.value,
        question: question.value,
      );
      await _analyticsService.logEvent(
        AnalyticsEvents.caseCreated,
        parameters: {
          'relationship_type': relationshipType.value,
          'category': category.value,
          'description_length': description.value.length,
          'question_length': question.value.length,
        },
      );
      reset();
      return caseId;
    } finally {
      isSubmitting.value = false;
    }
  }

  void reset() {
    currentStep.value = 0;
    relationshipType.value = '';
    category.value = '';
    description.value = '';
    question.value = '';
    validateStep();
  }

  bool get _isCurrentStepValid {
    switch (currentStep.value) {
      case 0:
        return isRelationshipValid.value;
      case 1:
        return isCategoryValid.value;
      case 2:
        return isDescriptionValid.value;
      case 3:
        return isQuestionValid.value;
      default:
        return true;
    }
  }

  bool get _isAllValid =>
      isRelationshipValid.value &&
      isCategoryValid.value &&
      isDescriptionValid.value &&
      isQuestionValid.value;
}
