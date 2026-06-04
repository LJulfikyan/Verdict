import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/premium_service.dart';
import '../../../data/models/case_model.dart';
import '../../../data/models/case_feed_page.dart';
import '../../../data/models/profile_statistics_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  ProfileController({
    required AuthService authService,
    required AnalyticsService analyticsService,
    required PremiumService premiumService,
    required UserRepository userRepository,
  }) : _authService = authService,
       _analyticsService = analyticsService,
       _premiumService = premiumService,
       _userRepository = userRepository;

  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final PremiumService _premiumService;
  final UserRepository _userRepository;

  final Rxn<UserModel> profile = Rxn<UserModel>();
  final Rxn<ProfileStatisticsModel> statistics = Rxn<ProfileStatisticsModel>();
  final RxList<CaseModel> savedCases = <CaseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSavedCases = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxnString errorMessage = RxnString();
  final RxnString savedCasesError = RxnString();
  DocumentSnapshot<Map<String, dynamic>>? _lastSavedCaseDocument;

  bool get isPremium => _premiumService.isPremium;
  bool get hasProfile => profile.value != null;
  bool get hasSavedCases => savedCases.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    refreshProfile();
    _analyticsService.logEvent(AnalyticsEvents.profileOpened);
  }

  Future<void> loadProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      profile.value = null;
      return;
    }
    final storedProfile = await _userRepository.getUser(user.uid);
    profile.value =
        (storedProfile ??
                UserModel(
                  id: user.uid,
                  isGuest: user.isAnonymous,
                  provider: user.providerData.isNotEmpty
                      ? user.providerData.first.providerId
                      : user.isAnonymous
                      ? 'guest'
                      : 'unknown',
                  displayName: user.displayName,
                  photoUrl: user.photoURL,
                  premium: _premiumService.isPremium,
                  createdAt: user.metadata.creationTime,
                ))
            .copyWith(premium: _premiumService.isPremium);
  }

  Future<void> loadStatistics() async {
    final user = _authService.currentUser;
    if (user == null) {
      statistics.value = const ProfileStatisticsModel.empty();
      return;
    }
    statistics.value = await _userRepository.getProfileStatistics(user.uid);
  }

  Future<void> loadSavedCases({bool reset = false}) async {
    final user = _authService.currentUser;
    if (user == null) {
      savedCases.clear();
      hasMore.value = false;
      return;
    }

    if (reset) {
      _lastSavedCaseDocument = null;
      hasMore.value = true;
      savedCases.clear();
      savedCasesError.value = null;
    }

    if (!hasMore.value || isLoadingSavedCases.value || isLoadingMore.value) {
      return;
    }

    final isFirstPage = _lastSavedCaseDocument == null;
    if (isFirstPage) {
      isLoadingSavedCases.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final page = await _userRepository.getSavedCasesPage(
        userId: user.uid,
        startAfter: _lastSavedCaseDocument,
        limit: 20,
      );
      _appendSavedCases(page, reset: isFirstPage && reset);
    } catch (_) {
      savedCasesError.value = 'Could not load saved cases right now.';
    } finally {
      isLoadingSavedCases.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() => loadSavedCases();

  Future<void> refreshProfile() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await Future.wait([
        loadProfile(),
        loadStatistics(),
        loadSavedCases(reset: true),
      ]);
    } catch (_) {
      errorMessage.value = 'Could not load your profile right now.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> trackSavedCasesOpened() {
    return _analyticsService.logEvent(AnalyticsEvents.savedCasesOpened);
  }

  Future<void> trackPremiumBannerClicked() {
    return _analyticsService.logEvent(AnalyticsEvents.premiumBannerClicked);
  }

  void _appendSavedCases(CaseFeedPage page, {required bool reset}) {
    if (reset) {
      savedCases.assignAll(page.items);
    } else {
      savedCases.addAll(page.items);
    }
    _lastSavedCaseDocument = page.lastDocument;
    hasMore.value = page.hasMore;
  }
}
