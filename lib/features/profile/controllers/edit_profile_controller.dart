import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class EditProfileController extends GetxController {
  EditProfileController({
    required AuthService authService,
    required AnalyticsService analyticsService,
    required UserRepository userRepository,
  }) : _authService = authService,
       _analyticsService = analyticsService,
       _userRepository = userRepository;

  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final UserRepository _userRepository;

  final formKey = GlobalKey<FormState>();
  final displayNameController = TextEditingController();
  final countryController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final RxString selectedAgeRange = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxnString errorMessage = RxnString();
  final RxBool hasInitialized = false.obs;

  static const genders = <String>[
    'Female',
    'Male',
    'Non-binary',
    'Prefer not to say',
  ];
  static const ageRanges = <String>[
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55+',
    'Prefer not to say',
  ];

  Future<void> initialize() async {
    if (hasInitialized.value) {
      return;
    }
    hasInitialized.value = true;
    await _analyticsService.logEvent(AnalyticsEvents.editProfileOpened);
    await loadProfile();
  }

  Future<void> loadProfile() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      errorMessage.value = 'Sign in to edit your profile.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    try {
      final user = await _userRepository.getUser(userId);
      _applyUser(user);
    } catch (_) {
      errorMessage.value = 'Could not load your profile right now.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> save() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      errorMessage.value = 'Sign in to edit your profile.';
      return false;
    }

    isSaving.value = true;
    errorMessage.value = null;
    try {
      await _userRepository.updateProfile(
        userId: userId,
        displayName: displayNameController.text.trim(),
        country: countryController.text.trim(),
        gender: selectedGender.value.trim(),
        ageRange: selectedAgeRange.value.trim(),
      );
      await _analyticsService.logEvent(AnalyticsEvents.profileUpdated);
      return true;
    } catch (_) {
      errorMessage.value = 'Could not save your profile right now.';
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  void _applyUser(UserModel? user) {
    displayNameController.text = user?.displayName ?? '';
    countryController.text = user?.country ?? '';
    selectedGender.value = user?.gender ?? '';
    selectedAgeRange.value = user?.ageRange ?? '';
  }

  @override
  void onClose() {
    displayNameController.dispose();
    countryController.dispose();
    super.onClose();
  }
}
