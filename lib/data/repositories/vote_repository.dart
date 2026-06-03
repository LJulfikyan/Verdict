import '../../core/constants/api_constants.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/functions_datasource.dart';
import '../models/vote_model.dart';

class VoteRepository {
  VoteRepository({
    required FirestoreDataSource firestoreDataSource,
    required FunctionsDataSource functionsDataSource,
  }) : _firestoreDataSource = firestoreDataSource,
       _functionsDataSource = functionsDataSource;

  final FirestoreDataSource _firestoreDataSource;
  final FunctionsDataSource _functionsDataSource;

  Future<Map<String, int>> vote({
    required String caseId,
    required String option,
  }) async {
    final result = await _functionsDataSource.call(
      ApiConstants.voteCase,
      parameters: {'caseId': caseId, 'option': option},
    );
    return Map<String, int>.from(result['results'] as Map? ?? const {});
  }

  Future<Map<String, VoteModel>> getVotesForCases({
    required String userId,
    required Iterable<String> caseIds,
  }) async {
    final ids = caseIds.toList(growable: false);
    final snapshots = await Future.wait(
      ids.map(
        (caseId) =>
            _firestoreDataSource.fetchVote(caseId: caseId, userId: userId),
      ),
    );

    final votes = <String, VoteModel>{};
    for (final snapshot in snapshots) {
      final data = snapshot.data();
      if (snapshot.exists && data != null) {
        votes[snapshot.reference.parent.parent!.id] = VoteModel.fromMap(data);
      }
    }
    return votes;
  }
}
