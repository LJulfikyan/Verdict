import 'package:firebase_core/firebase_core.dart';

import '../../data/models/case_model.dart';
import '../../data/models/vote_submission_result.dart';
import '../../data/repositories/case_repository.dart';
import '../../data/repositories/vote_repository.dart';
import '../constants/analytics_events.dart';
import 'analytics_service.dart';
import 'share_service.dart';

class CaseActionService {
  CaseActionService({
    required CaseRepository caseRepository,
    required VoteRepository voteRepository,
    required AnalyticsService analyticsService,
    required ShareService shareService,
  }) : _caseRepository = caseRepository,
       _voteRepository = voteRepository,
       _analyticsService = analyticsService,
       _shareService = shareService;

  final CaseRepository _caseRepository;
  final VoteRepository _voteRepository;
  final AnalyticsService _analyticsService;
  final ShareService _shareService;

  Future<VoteSubmissionResult> vote({
    required CaseModel caseModel,
    required String option,
  }) async {
    final result = await _voteRepository.vote(
      caseId: caseModel.id,
      option: option,
    );
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
    return result;
  }

  Future<bool> toggleSaveCase({
    required CaseModel caseModel,
    required bool isCurrentlySaved,
  }) async {
    await _caseRepository.saveCase(caseModel.id);
    return !isCurrentlySaved;
  }

  Future<void> shareCase(CaseModel caseModel) {
    return _shareService.shareText(
      '${caseModel.question}\n\n${caseModel.description}',
      subject: 'Verdict case',
    );
  }

  String mapVoteError(FirebaseException error) {
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
}
