import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/errors.dart';

abstract final class DebugLogger {
  static void logInfo({
    required String module,
    required String className,
    required String method,
    required String message,
    Map<String, Object?>? additionalDetails,
  }) {
    if (!kDebugMode) {
      return;
    }

    final buffer = StringBuffer()
      ..writeln('[$module]')
      ..writeln('Class: $className')
      ..writeln('Method: $method')
      ..writeln('Error Type: None')
      ..writeln('Message: $message')
      ..writeln(
        'Additional Details: ${_formatDetails(additionalDetails ?? const <String, Object?>{})}',
      )
      ..writeln('Stack Trace: None');

    debugPrint(buffer.toString());
  }

  static void logError({
    required String module,
    required String className,
    required String method,
    required Object error,
    required StackTrace stackTrace,
    Map<String, Object?>? additionalDetails,
  }) {
    if (!kDebugMode) {
      return;
    }

    final details = <String, Object?>{
      ..._extractSpecialDetails(error),
      ...?additionalDetails,
    };

    final buffer = StringBuffer()
      ..writeln('[$module]')
      ..writeln('Class: $className')
      ..writeln('Method: $method')
      ..writeln('Error Type: ${error.runtimeType}')
      ..writeln('Message: $error')
      ..writeln('Additional Details: ${_formatDetails(details)}')
      ..writeln('Stack Trace: $stackTrace');

    debugPrint(buffer.toString());
  }

  static void logState({
    required String module,
    required String className,
    required String method,
    required String state,
    Object? from,
    Object? to,
    Map<String, Object?>? additionalDetails,
  }) {
    logInfo(
      module: module,
      className: className,
      method: method,
      message: 'State transition for $state',
      additionalDetails: {
        'state': state,
        'from': from,
        'to': to,
        ...?additionalDetails,
      },
    );
  }

  static void logNavigation({
    required String module,
    required String className,
    required String method,
    required String currentRoute,
    required String targetRoute,
    String status = 'attempt',
    Map<String, Object?>? additionalDetails,
  }) {
    logInfo(
      module: module,
      className: className,
      method: method,
      message: 'Navigation $status',
      additionalDetails: {
        'currentRoute': currentRoute,
        'targetRoute': targetRoute,
        ...?additionalDetails,
      },
    );
  }

  static void logQuery({
    required String module,
    required String className,
    required String method,
    required String query,
    Map<String, Object?>? parameters,
  }) {
    logInfo(
      module: module,
      className: className,
      method: method,
      message: query,
      additionalDetails: parameters,
    );
  }

  static Map<String, Object?> _extractSpecialDetails(Object error) {
    final details = <String, Object?>{};

    if (error is FirebaseAuthException) {
      details.addAll({
        'firebaseAuth.code': error.code,
        'firebaseAuth.email': error.email,
        'firebaseAuth.credential': error.credential?.providerId,
      });
    }

    if (error is FirebaseFunctionsException) {
      details.addAll({
        'functions.code': error.code,
        'functions.message': error.message,
        'functions.details': error.details,
      });
    }

    if (error is FirebaseException) {
      details.addAll({
        'firebase.plugin': error.plugin,
        'firebase.code': error.code,
        'firebase.message': error.message,
      });
    }

    if (error is PlatformException) {
      details.addAll({
        'platform.code': error.code,
        'platform.message': error.message,
        'platform.details': error.details,
      });

      final isRevenueCatError =
          error.code.startsWith('PURCHASES_') ||
          error.message?.toLowerCase().contains('purchase') == true ||
          error.message?.toLowerCase().contains('revenuecat') == true;

      if (isRevenueCatError) {
        try {
          final purchasesCode = PurchasesErrorHelper.getErrorCode(error);
          details['revenueCat.code'] = purchasesCode.name;
        } catch (_) {
          details['revenueCat.code'] = 'unavailable';
        }
      }
    }

    details.addAll(_extractDioDetails(error));
    return details;
  }

  static Map<String, Object?> _extractDioDetails(Object error) {
    final dynamic dynamicError = error;
    try {
      final response = dynamicError.response;
      final requestOptions = dynamicError.requestOptions;
      return <String, Object?>{
        'dio.requestUrl': requestOptions?.uri?.toString(),
        'dio.requestMethod': requestOptions?.method?.toString(),
        'dio.statusCode': response?.statusCode,
        'dio.responseBody': response?.data?.toString(),
      };
    } catch (_) {
      return const <String, Object?>{};
    }
  }

  static String _formatDetails(Map<String, Object?> details) {
    if (details.isEmpty) {
      return 'None';
    }
    return details.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join(', ');
  }
}
