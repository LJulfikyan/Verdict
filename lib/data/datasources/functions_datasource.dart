import 'package:cloud_functions/cloud_functions.dart';

class FunctionsDataSource {
  FunctionsDataSource({required FirebaseFunctions functions})
    : _functions = functions;

  final FirebaseFunctions _functions;

  Future<Map<String, dynamic>> call(
    String functionName, {
    Map<String, dynamic>? parameters,
  }) async {
    final result = await _functions
        .httpsCallable(functionName)
        .call(parameters);
    if (result.data is Map<String, dynamic>) {
      return result.data as Map<String, dynamic>;
    }
    return Map<String, dynamic>.from(result.data as Map);
  }
}
