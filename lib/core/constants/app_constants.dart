import 'package:flutter/foundation.dart';

abstract final class AppConstants {
  static const appName = 'Verdict';
  static const defaultFeedPageSize = 20;
  static const nativeAdFrequency = 10;
  static const interstitialVoteThreshold = 50;
  static const maxInterstitialsPerDay = 3;
  static const interstitialCooldownMinutes = 30;
  static const onboardingCompletedKey = 'onboarding_completed';
  static const lastInterstitialShownAtKey = 'last_interstitial_shown_at';
  static const interstitialDailyCountKey = 'interstitial_daily_count';
  static const voteCountSinceInterstitialKey = 'vote_count_since_interstitial';

  static const revenueCatAndroidApiKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_API_KEY',
  );
  static const revenueCatIosApiKey = String.fromEnvironment(
    'REVENUECAT_IOS_API_KEY',
  );
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );
  static const admobAndroidAppId = String.fromEnvironment(
    'ADMOB_ANDROID_APP_ID',
  );
  static const admobIosAppId = String.fromEnvironment('ADMOB_IOS_APP_ID');
  static const admobAndroidInterstitialId = String.fromEnvironment(
    'ADMOB_ANDROID_INTERSTITIAL_ID',
  );
  static const admobIosInterstitialId = String.fromEnvironment(
    'ADMOB_IOS_INTERSTITIAL_ID',
  );
  static const admobAndroidNativeId = String.fromEnvironment(
    'ADMOB_ANDROID_NATIVE_ID',
  );
  static const admobIosNativeId = String.fromEnvironment('ADMOB_IOS_NATIVE_ID');

  static const testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const testNativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';

  static bool get isProduction => kReleaseMode;
}
