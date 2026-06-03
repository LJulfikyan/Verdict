import 'package:get/get.dart';

import '../../../core/services/app_state_service.dart';

class OnboardingController extends GetxController {
  OnboardingController({required AppStateService appStateService})
    : _appStateService = appStateService;

  final AppStateService _appStateService;

  final RxInt currentPage = 0.obs;
  final RxBool isLastPage = false.obs;

  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value += 1;
      _sync();
    }
  }

  void previousPage() {
    currentPage.value = currentPage.value > 0 ? currentPage.value - 1 : 0;
    _sync();
  }

  Future<void> completeOnboarding() => _appStateService.completeOnboarding();

  void setPage(int index) {
    currentPage.value = index;
    _sync();
  }

  void _sync() {
    isLastPage.value = currentPage.value >= 2;
  }
}
