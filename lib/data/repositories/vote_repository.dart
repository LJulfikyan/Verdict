import '../../core/constants/api_constants.dart';
import '../datasources/functions_datasource.dart';

class VoteRepository {
  VoteRepository({required FunctionsDataSource functionsDataSource})
    : _functionsDataSource = functionsDataSource;

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
}
