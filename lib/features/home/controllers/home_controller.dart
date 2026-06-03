import 'package:get/get.dart';

import '../../../core/services/share_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/case_model.dart';
import '../../../data/repositories/case_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/vote_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FeedState { loading, success, empty, error }

class HomeController extends GetxController {
  HomeController({
    required CaseRepository caseRepository,
    required VoteRepository voteRepository,
    required UserRepository userRepository,
    required AuthService authService,
    required ShareService shareService,
  }) : _caseRepository = caseRepository,
       _voteRepository = voteRepository,
       _userRepository = userRepository,
       _authService = authService,
       _shareService = shareService;

  final CaseRepository _caseRepository;
  final VoteRepository _voteRepository;
  final UserRepository _userRepository;
  final AuthService _authService;
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
  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;

  @override
  void onInit() {
    super.onInit();
    loadFeed();
  }

  Future<void> loadFeed() async {
    isLoading.value = true;
    feedState.value = FeedState.loading;
    try {
      _lastDocument = null;
      final page = await _caseRepository.getFeed();
      final hydratedItems = await _hydrateFeed(page.items);
      feedItems.assignAll(hydratedItems);
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
      _lastDocument = page.lastDocument;
      hasMore.value = page.hasMore;
      await _refreshSavedStates();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> vote(CaseModel caseModel, String option) async {
    if (caseModel.userVote != null) {
      return;
    }

    busyVotes[caseModel.id] = true;
    try {
      final results = await _voteRepository.vote(
        caseId: caseModel.id,
        option: option,
      );
      final index = feedItems.indexWhere((item) => item.id == caseModel.id);
      if (index >= 0) {
        feedItems[index] = feedItems[index].copyWith(
          userVote: option,
          results: results,
          votesCount: caseModel.votesCount + 1,
        );
      }
    } finally {
      busyVotes[caseModel.id] = false;
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
}
