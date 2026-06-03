import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  AnalyticsService({required FirebaseAnalytics analytics})
    : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  Future<AnalyticsService> init() async {
    await _analytics.setAnalyticsCollectionEnabled(true);
    return this;
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> setUserId(String? userId) => _analytics.setUserId(id: userId);

  Future<void> setUserProperty({required String name, required String? value}) {
    return _analytics.setUserProperty(name: name, value: value);
  }
}
