import '../../core/constants/api_constants.dart';
import '../datasources/functions_datasource.dart';

class ReportRepository {
  ReportRepository({required FunctionsDataSource functionsDataSource})
    : _functionsDataSource = functionsDataSource;

  final FunctionsDataSource _functionsDataSource;

  Future<void> reportCase({
    required String caseId,
    required String reason,
  }) async {
    await _functionsDataSource.call(
      ApiConstants.reportCase,
      parameters: {'caseId': caseId, 'reason': reason},
    );
  }
}
