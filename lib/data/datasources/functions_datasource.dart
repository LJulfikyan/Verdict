import 'package:cloud_functions/cloud_functions.dart';

import '../../core/services/debug_logger.dart';

class FunctionsDataSource {
  FunctionsDataSource({required FirebaseFunctions functions})
    : _functions = functions;

  final FirebaseFunctions _functions;

  Future<Map<String, dynamic>> call(
    String functionName, {
    Map<String, dynamic>? parameters,
  }) async {
    DebugLogger.logInfo(
      module: 'Functions',
      className: 'FunctionsDataSource',
      method: 'call',
      message: 'Calling Cloud Function',
      additionalDetails: {
        'functionName': functionName,
        'parameters': parameters,
      },
    );
    try {
      final result = await _functions
          .httpsCallable(functionName)
          .call(parameters);
      if (result.data is Map<String, dynamic>) {
        return result.data as Map<String, dynamic>;
      }
      return Map<String, dynamic>.from(result.data as Map);
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Functions',
        className: 'FunctionsDataSource',
        method: 'call',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {
          'functionName': functionName,
          'parameters': parameters,
        },
      );
      rethrow;
    }
  }
}
