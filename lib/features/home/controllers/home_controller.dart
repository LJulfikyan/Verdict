import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/case_model.dart';
import '../../../data/repositories/case_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/vote_repository.dart';

enum FeedState { loading, success, empty, error }

class HomeController extends GetxController {
  HomeController({
    required CaseRepository caseRepository,
    required VoteRepository voteRepository,
    required UserRepository userRepository,
    required AuthService authService,
    required AnalyticsService analyticsService,
    required ShareService shareService,
  }) : _caseRepository = caseRepository,
       _voteRepository = voteRepository,
       _userRepository = userRepository,
       _authService = authService,
       _analyticsService = analyticsService,
       _shareService = shareService;

  final CaseRepository _caseRepository;
  final VoteRepository _voteRepository;
  final UserRepository _userRepository;
  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final ShareService _shareService;

  final RxList<CaseModel> feedItems = <CaseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<CaseModel> selectedCase = Rxn<CaseModel>();
  final Rx<FeedState> feedState = FeedState.loading.obs;
  final RxSet<String> savedCaseIds = <String>{}.obs;
  final RxMap<String, bool> expandedCaseIds = <String, bool>{}.obs;
  final RxMap<String, bool> busyVotes = <String, bool>{}.obs;
  final RxMap<String, String> pendingVoteOptions = <String, String>{}.obs;
  final RxMap<String, String> voteErrors = <String, String>{}.obs;
  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;
  final Map<String, StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>>
  _caseSubscriptions =
      <String, StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>>{};

  @override
  void onInit() {
    super.onInit();
    loadFeed();
  }

  Future<void> loadFeed() async {
    isLoading.value = true;
    feedState.value = FeedState.loading;
    try {
      _disposeCaseSubscriptions();
      _lastDocument = null;
      final page = await _caseRepository.getFeed();
      final hydratedItems = await _hydrateFeed(page.items);
      feedItems.assignAll(hydratedItems);
      _subscribeToCases(hydratedItems);
      _lastDocument = page.lastDocument;
      hasMore.value = page.hasMore;
      await _refreshSavedStates();
      feedState.value = hydratedItems.isEmpty
          ? FeedState.empty
          : FeedState.success;
    } catch (_) {
      feedState.value = FeedState.error;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFeed() async {
    isRefreshing.value = true;
    try {
      await loadFeed();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || !hasMore.value || _lastDocument == null) {
      return;
    }

    isLoading.value = true;
    try {
      final page = await _caseRepository.getFeed(startAfter: _lastDocument);
      final hydratedItems = await _hydrateFeed(page.items);
      feedItems.addAll(hydratedItems);
      _subscribeToCases(hydratedItems);
      _lastDocument = page.lastDocument;
      hasMore.value = page.hasMore;
      await _refreshSavedStates();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> vote(CaseModel caseModel, String option) async {
    if (caseModel.userVote != null || isVoteBusy(caseModel.id)) {
      return;
    }

    voteErrors.remove(caseModel.id);
    busyVotes[caseModel.id] = true;
    pendingVoteOptions[caseModel.id] = option;
    try {
      final result = await _voteRepository.vote(
        caseId: caseModel.id,
        option: option,
      );
      final index = feedItems.indexWhere((item) => item.id == caseModel.id);
      if (index >= 0) {
        feedItems[index] = feedItems[index].copyWith(
          userVote: option,
          results: result.results,
          votesCount: result.votesCount,
          winnerOption: result.winnerOption,
          hotScore: result.hotScore,
        );
        feedItems.refresh();
      }
      await _analyticsService.logEvent(
        AnalyticsEvents.caseVote,
        parameters: {
          'vote_option': option,
          'relationship_type': caseModel.relationshipType,
          'category': caseModel.category,
        },
      );
      await _analyticsService.logEvent(
        AnalyticsEvents.voteOption,
        parameters: {
          'vote_option': option,
          'relationship_type': caseModel.relationshipType,
          'category': caseModel.category,
        },
      );
    } on FirebaseException catch (error) {
      voteErrors[caseModel.id] = _mapVoteError(error);
      Get.snackbar('Vote failed', voteErrors[caseModel.id]!);
    } catch (_) {
      voteErrors[caseModel.id] = 'Could not submit your vote right now.';
      Get.snackbar('Vote failed', voteErrors[caseModel.id]!);
    } finally {
      busyVotes[caseModel.id] = false;
      pendingVoteOptions.remove(caseModel.id);
    }
  }

  Future<void> toggleSaveCase(CaseModel caseModel) async {
    await _caseRepository.saveCase(caseModel.id);
    if (savedCaseIds.contains(caseModel.id)) {
      savedCaseIds.remove(caseModel.id);
    } else {
      savedCaseIds.add(caseModel.id);
    }
  }

  Future<void> shareCase(CaseModel caseModel) {
    return _shareService.shareText(
      '${caseModel.question}\n\n${caseModel.description}',
      subject: 'Verdict case',
    );
  }

  void openCase(CaseModel caseModel) {
    selectedCase.value = caseModel;
  }

  void toggleExpanded(String caseId) {
    expandedCaseIds[caseId] = !(expandedCaseIds[caseId] ?? false);
  }

  bool isSaved(String caseId) => savedCaseIds.contains(caseId);

  bool isExpanded(String caseId) => expandedCaseIds[caseId] ?? false;

  bool isVoteBusy(String caseId) => busyVotes[caseId] ?? false;
  String? pendingVoteOption(String caseId) => pendingVoteOptions[caseId];

  String? voteError(String caseId) => voteErrors[caseId];

  Future<List<CaseModel>> _hydrateFeed(List<CaseModel> items) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null || items.isEmpty) {
      return items;
    }

    final votes = await _voteRepository.getVotesForCases(
      userId: currentUser.uid,
      caseIds: items.map((item) => item.id),
    );

    return items
        .map((item) => item.copyWith(userVote: votes[item.id]?.option))
        .toList(growable: false);
  }

  Future<void> _refreshSavedStates() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      savedCaseIds.clear();
      return;
    }

    savedCaseIds
      ..clear()
      ..addAll(await _userRepository.getSavedCaseIds(currentUser.uid));
  }

  void _subscribeToCases(List<CaseModel> items) {
    for (final item in items) {
      if (_caseSubscriptions.containsKey(item.id)) {
        continue;
      }
      _caseSubscriptions[item.id] = _caseRepository
          .watchCase(item.id)
          .listen(_handleCaseSnapshot);
    }
  }

  void _handleCaseSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final index = feedItems.indexWhere((item) => item.id == snapshot.id);
    if (index < 0) {
      return;
    }

    if (!snapshot.exists || snapshot.data() == null) {
      feedItems.removeAt(index);
      feedItems.refresh();
      return;
    }

    final latest = CaseModel.fromMap(snapshot.data()!, id: snapshot.id);
    if (!latest.isActive) {
      feedItems.removeAt(index);
      feedItems.refresh();
      return;
    }

    final previous = feedItems[index];
    feedItems[index] = latest.copyWith(userVote: previous.userVote);
    feedItems.refresh();
  }

  String _mapVoteError(FirebaseException error) {
    switch (error.code) {
      case 'already-exists':
        return 'You already voted on this case.';
      case 'not-found':
      case 'failed-precondition':
        return 'This case is no longer available.';
      case 'permission-denied':
      case 'unauthenticated':
        return 'You do not have permission to vote on this case.';
      case 'unavailable':
        return 'Network unavailable. Try again.';
      default:
        return 'Could not submit your vote right now.';
    }
  }

  void _disposeCaseSubscriptions() {
    for (final subscription in _caseSubscriptions.values) {
      subscription.cancel();
    }
    _caseSubscriptions.clear();
  }

  @override
  void onClose() {
    _disposeCaseSubscriptions();
    super.onClose();
  }
}
