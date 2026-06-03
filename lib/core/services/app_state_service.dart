import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class AppStateService extends GetxService with ChangeNotifier {
  AppStateService({required this.preferences});

  final SharedPreferences preferences;

  final RxBool _isReady = false.obs;
  final RxBool _onboardingCompleted = false.obs;

  bool get isReady => _isReady.value;
  bool get onboardingCompleted => _onboardingCompleted.value;

  Future<AppStateService> init() async {
    _onboardingCompleted.value =
        preferences.getBool(AppConstants.onboardingCompletedKey) ?? false;
    return this;
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted.value = true;
    await preferences.setBool(AppConstants.onboardingCompletedKey, true);
    notifyListeners();
  }

  void markReady() {
    _onboardingCompleted.value =
        preferences.getBool(AppConstants.onboardingCompletedKey) ?? false;
    _isReady.value = true;
    notifyListeners();
  }
}
