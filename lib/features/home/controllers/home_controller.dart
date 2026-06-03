import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/constants/analytics_events.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/services/share_service.dart';
import '../../../data/models/case_model.dart';
import '../../../data/repositories/case_repository.dart';
import '../../../data/repositories/vote_repository.dart';

enum FeedState { loading, success, empty, error }

class HomeController extends GetxController {
  HomeController({
    required CaseRepository caseRepository,
    required VoteRepository voteRepository,
    required AnalyticsService analyticsService,
    required AdService adService,
    required ShareService shareService,
  }) : _caseRepository = caseRepository,
       _voteRepository = voteRepository,
       _analyticsService = analyticsService,
       _adService = adService,
       _shareService = shareService;

  final CaseRepository _caseRepository;
  final VoteRepository _voteRepository;
  final AnalyticsService _analyticsService;
  final AdService _adService;
  final ShareService _shareService;

  final RxList<CaseModel> feedItems = <CaseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<CaseModel> selectedCase = Rxn<CaseModel>();
  final Rx<FeedState> feedState = FeedState.loading.obs;
  final RxString selectedVote = ''.obs;
  final RxBool isVoting = false.obs;
  final RxMap<String, int> voteResult = <String, int>{}.obs;

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
      final page = await _caseRepository.getFeed();
      feedItems.assignAll(page.items);
      _lastDocument = page.lastDocument;
      hasMore.value = page.hasMore;
      feedState.value = page.items.isEmpty
          ? FeedState.empty
          : FeedState.success;
      await _analyticsService.logEvent(AnalyticsEvents.feedOpen);
    } catch (_) {
      feedState.value = FeedState.error;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshFeed() async {
    isRefreshing.value = true;
    _lastDocument = null;
    try {
      await loadFeed();
      await _analyticsService.logEvent(AnalyticsEvents.feedRefresh);
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
      feedItems.addAll(page.items);
      _lastDocument = page.lastDocument;
      hasMore.value = page.hasMore;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> vote(CaseModel caseModel, String option) async {
    isVoting.value = true;
    selectedVote.value = option;
    try {
      final results = await _voteRepository.vote(
        caseId: caseModel.id,
        option: option,
      );
      voteResult.assignAll(results);
      final index = feedItems.indexWhere((item) => item.id == caseModel.id);
      if (index >= 0) {
        feedItems[index] = feedItems[index].copyWith(
          userVote: option,
          results: results,
          votesCount: caseModel.votesCount + 1,
        );
      }
      await _analyticsService.logEvent(
        AnalyticsEvents.caseVote,
        parameters: {
          'case_id': caseModel.id,
          'vote_option': option,
          'category': caseModel.category,
          'relationship_type': caseModel.relationshipType,
        },
      );
      await _adService.registerVote();
      await _adService.maybeShowInterstitial();
    } finally {
      isVoting.value = false;
    }
  }

  Future<void> saveCase(CaseModel caseModel) =>
      _caseRepository.saveCase(caseModel.id);

  Future<void> shareCase(CaseModel caseModel) {
    return _shareService.shareText(
      '${caseModel.question}\n\n${caseModel.description}',
      subject: 'Verdict case',
    );
  }

  void openCase(CaseModel caseModel) {
    selectedCase.value = caseModel;
  }
}
