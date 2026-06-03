import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CrashlyticsService extends GetxService {
  CrashlyticsService({required FirebaseCrashlytics crashlytics})
    : _crashlytics = crashlytics;

  final FirebaseCrashlytics _crashlytics;

  Future<CrashlyticsService> init() async {
    FlutterError.onError = _crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
    return this;
  }

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  }) {
    return _crashlytics.recordError(error, stackTrace, fatal: fatal);
  }

  Future<void> log(String message) => _crashlytics.log(message);
}
