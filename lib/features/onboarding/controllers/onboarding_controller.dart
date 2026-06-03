import 'package:get/get.dart';

import '../../../core/services/app_state_service.dart';

class OnboardingController extends GetxController {
  OnboardingController({required AppStateService appStateService})
    : _appStateService = appStateService;

  final AppStateService _appStateService;

  final RxInt currentPage = 0.obs;
  final RxBool isLastPage = false.obs;

  void nextPage() {
    currentPage.value += 1;
    isLastPage.value = currentPage.value >= 2;
  }

  void previousPage() {
    currentPage.value = currentPage.value > 0 ? currentPage.value - 1 : 0;
    isLastPage.value = currentPage.value >= 2;
  }

  Future<void> completeOnboarding() => _appStateService.completeOnboarding();
}
