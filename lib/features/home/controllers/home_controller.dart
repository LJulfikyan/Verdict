import 'package:get/get.dart';

import '../../../core/services/share_service.dart';
import '../../../data/models/case_model.dart';
import '../repositories/home_mock_repository.dart';

enum FeedState { loading, success, empty, error }

class HomeController extends GetxController {
  HomeController({
    required HomeMockRepository repository,
    required ShareService shareService,
  }) : _repository = repository,
       _shareService = shareService;

  final HomeMockRepository _repository;
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
  int _currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    loadFeed();
  }

  Future<void> loadFeed() async {
    isLoading.value = true;
    feedState.value = FeedState.loading;
    try {
      _currentPage = 0;
      final page = await _repository.fetchFeed(page: _currentPage);
      feedItems.assignAll(page);
      hasMore.value = page.length == HomeMockRepository.pageSize;
      feedState.value = page.isEmpty ? FeedState.empty : FeedState.success;
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
    if (isLoading.value || !hasMore.value) {
      return;
    }

    isLoading.value = true;
    try {
      _currentPage += 1;
      final page = await _repository.fetchFeed(page: _currentPage);
      feedItems.addAll(page);
      hasMore.value = page.length == HomeMockRepository.pageSize;
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
      await Future<void>.delayed(const Duration(milliseconds: 180));
      final results = _nextResults(caseModel.results, option);
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

  void toggleSaveCase(CaseModel caseModel) {
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

  Map<String, int> _nextResults(Map<String, int> current, String option) {
    final updated = Map<String, int>.from(current);
    updated[option] = (updated[option] ?? 0) + 1;
    return updated;
  }
}
