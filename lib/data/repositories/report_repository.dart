import '../../core/constants/api_constants.dart';
import '../../core/services/debug_logger.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/functions_datasource.dart';
import '../models/report_model.dart';

class ReportRepository {
  ReportRepository({
    required FirestoreDataSource firestoreDataSource,
    required FunctionsDataSource functionsDataSource,
  }) : _firestoreDataSource = firestoreDataSource,
       _functionsDataSource = functionsDataSource;

  final FirestoreDataSource _firestoreDataSource;
  final FunctionsDataSource _functionsDataSource;

  Future<void> reportCase({
    required String caseId,
    required String reason,
  }) async {
    try {
      await _functionsDataSource.call(
        ApiConstants.reportCase,
        parameters: {'caseId': caseId, 'reason': reason},
      );
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'ReportRepository',
        method: 'reportCase',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {'caseId': caseId, 'reason': reason},
      );
      rethrow;
    }
  }

  Future<List<ReportModel>> getReportsForCase(String caseId) async {
    final snapshot = await _firestoreDataSource
        .reportsForCaseCollection(caseId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ReportModel.fromMap(doc.data()))
        .toList(growable: false);
  }
}
