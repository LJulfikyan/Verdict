import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/case_action_service.dart';
import '../../../data/models/case_model.dart';
import '../../../data/repositories/case_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/vote_repository.dart';

enum CaseDetailState { loading, success, error, notFound }

class CaseDetailController extends GetxController {
  CaseDetailController({
    required CaseRepository caseRepository,
    required VoteRepository voteRepository,
    required UserRepository userRepository,
    required AuthService authService,
    required AnalyticsService analyticsService,
    required CaseActionService caseActionService,
  }) : _caseRepository = caseRepository,
       _voteRepository = voteRepository,
       _userRepository = userRepository,
       _authService = authService,
       _analyticsService = analyticsService,
       _caseActionService = caseActionService;

  final CaseRepository _caseRepository;
  final VoteRepository _voteRepository;
  final UserRepository _userRepository;
  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final CaseActionService _caseActionService;

  final Rx<CaseDetailState> state = CaseDetailState.loading.obs;
  final Rxn<CaseModel> caseModel = Rxn<CaseModel>();
  final RxBool isSaved = false.obs;
  final RxBool isVoting = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isExpanded = false.obs;
  final RxnString pendingVoteOption = RxnString();
  final RxnString errorMessage = RxnString();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;
  String? _caseId;

  Future<void> initialize(String caseId) async {
    if (_caseId == caseId && state.value != CaseDetailState.error) {
      return;
    }
    _caseId = caseId;
    await loadCase();
  }

  Future<void> loadCase() async {
    final caseId = _caseId;
    if (caseId == null || caseId.isEmpty) {
      state.value = CaseDetailState.notFound;
      return;
    }

    state.value = CaseDetailState.loading;
    errorMessage.value = null;
    try {
      final item = await _caseRepository.getCaseById(caseId);
      if (item == null || !item.isActive) {
        state.value = CaseDetailState.notFound;
        caseModel.value = null;
        return;
      }

      final hydrated = await _hydrateCase(item);
      caseModel.value = hydrated;
      isSaved.value = await _loadSavedState(caseId);
      _subscribe(caseId);
      state.value = CaseDetailState.success;
      await _analyticsService.logEvent(
        AnalyticsEvents.caseDetailOpened,
        parameters: {'case_id': caseId, 'category': hydrated.category},
      );
    } catch (_) {
      errorMessage.value = 'Could not load this case right now.';
      state.value = CaseDetailState.error;
    }
  }

  Future<void> vote(String option) async {
    final item = caseModel.value;
    if (item == null || item.userVote != null || isVoting.value) {
      return;
    }

    isVoting.value = true;
    pendingVoteOption.value = option;
    try {
      final result = await _caseActionService.vote(
        caseModel: item,
        option: option,
      );
      caseModel.value = item.copyWith(
        userVote: option,
        results: result.results,
        votesCount: result.votesCount,
        winnerOption: result.winnerOption,
        hotScore: result.hotScore,
      );
    } on FirebaseException catch (error) {
      Get.snackbar('Vote failed', _caseActionService.mapVoteError(error));
    } catch (_) {
      Get.snackbar('Vote failed', 'Could not submit your vote right now.');
    } finally {
      isVoting.value = false;
      pendingVoteOption.value = null;
    }
  }

  Future<void> toggleSave() async {
    final item = caseModel.value;
    if (item == null || isSaving.value) {
      return;
    }

    isSaving.value = true;
    try {
      isSaved.value = await _caseActionService.toggleSaveCase(
        caseModel: item,
        isCurrentlySaved: isSaved.value,
      );
    } catch (_) {
      Get.snackbar('Save failed', 'Could not update saved state right now.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> share() async {
    final item = caseModel.value;
    if (item == null) {
      return;
    }
    await _caseActionService.shareCase(item);
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  Future<CaseModel> _hydrateCase(CaseModel item) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return item;
    }

    final votes = await _voteRepository.getVotesForCases(
      userId: currentUser.uid,
      caseIds: [item.id],
    );
    return item.copyWith(userVote: votes[item.id]?.option);
  }

  Future<bool> _loadSavedState(String caseId) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return false;
    }
    final savedIds = await _userRepository.getSavedCaseIds(currentUser.uid);
    return savedIds.contains(caseId);
  }

  void _subscribe(String caseId) {
    _subscription?.cancel();
    _subscription = _caseRepository.watchCase(caseId).listen((snapshot) async {
      if (!snapshot.exists || snapshot.data() == null) {
        state.value = CaseDetailState.notFound;
        caseModel.value = null;
        return;
      }

      final latest = CaseModel.fromMap(snapshot.data()!, id: snapshot.id);
      if (!latest.isActive) {
        state.value = CaseDetailState.notFound;
        caseModel.value = null;
        return;
      }

      final previousVote = caseModel.value?.userVote;
      caseModel.value = latest.copyWith(userVote: previousVote);
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
