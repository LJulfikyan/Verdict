import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/utils/validators.dart';
import '../../../core/services/analytics_service.dart';
import '../../../data/repositories/case_repository.dart';

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
  final RxString lastCreatedCaseId = ''.obs;
  final RxString submissionError = ''.obs;

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

  void setStep(int step) {
    currentStep.value = step;
  }

  void setRelationshipType(String value) {
    relationshipType.value = value;
    validateStep();
  }

  void setCategory(String value) {
    category.value = value;
    validateStep();
  }

  void setDescription(String value) {
    description.value = value;
    validateStep();
  }

  void setQuestion(String value) {
    question.value = value;
    validateStep();
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
    submissionError.value = '';
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
      lastCreatedCaseId.value = caseId;
      reset();
      return caseId;
    } catch (error) {
      submissionError.value = _mapSubmissionError(error);
      rethrow;
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
    submissionError.value = '';
    validateStep();
  }

  double get progressValue => (currentStep.value + 1) / 4;

  String get currentRoute {
    switch (currentStep.value) {
      case 0:
        return RouteNames.createRelationship;
      case 1:
        return RouteNames.createCategory;
      case 2:
        return RouteNames.createDescription;
      case 3:
        return RouteNames.createQuestion;
      default:
        return RouteNames.createRelationship;
    }
  }

  String? get descriptionError =>
      Validators.validateCaseDescription(description.value);

  String? get questionError => Validators.validateQuestion(question.value);

  String _mapSubmissionError(Object error) {
    final message = error.toString();
    if (message.contains('description_too_short')) {
      return 'Description must be at least 50 characters.';
    }
    if (message.contains('description_too_long')) {
      return 'Description must be 500 characters or fewer.';
    }
    if (message.contains('invalid_relationship_type')) {
      return 'Please choose a relationship type.';
    }
    if (message.contains('invalid_category')) {
      return 'Please choose a category.';
    }
    if (message.contains('unauthorized')) {
      return 'You need to sign in before submitting a case.';
    }
    return 'Could not submit your case right now.';
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
