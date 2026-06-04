import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class AdService extends GetxService {
  AdService({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  final RxBool nativeAdsLoaded = false.obs;
  final RxBool canShowInterstitial = false.obs;
  final RxBool rewardReady = false.obs;
  final RxBool isConfigured = false.obs;

  final List<NativeAd> _nativeAds = <NativeAd>[];
  InterstitialAd? _interstitialAd;

  Future<AdService> init() async {
    isConfigured.value = _hasNativeAppId;
    if (!isConfigured.value) {
      debugPrint(
        'AdService: AdMob disabled because no native app ID is configured '
        'for ${Platform.operatingSystem}.',
      );
      return this;
    }

    await MobileAds.instance.initialize();
    await preloadNativeAds();
    await preloadInterstitial();
    _refreshInterstitialEligibility();
    return this;
  }

  List<NativeAd> get nativeAds => List.unmodifiable(_nativeAds);

  Future<void> preloadNativeAds({int count = 3}) async {
    if (!isConfigured.value) {
      nativeAdsLoaded.value = false;
      return;
    }

    _nativeAds.clear();
    for (var index = 0; index < count; index++) {
      final ad = NativeAd(
        adUnitId: _nativeAdUnitId,
        factoryId: 'feedNativeAd',
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (_) => nativeAdsLoaded.value = true,
          onAdFailedToLoad: (ad, error) =>
              nativeAdsLoaded.value = _nativeAds.isNotEmpty,
        ),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.medium,
        ),
      );
      await ad.load();
      _nativeAds.add(ad);
    }
  }

  Future<void> preloadInterstitial() async {
    if (!isConfigured.value) {
      canShowInterstitial.value = false;
      return;
    }

    final completer = Completer<void>();
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          canShowInterstitial.value = true;
          completer.complete();
        },
        onAdFailedToLoad: (_) {
          canShowInterstitial.value = false;
          completer.complete();
        },
      ),
    );
    await completer.future;
  }

  Future<void> registerVote() async {
    final count =
        (_preferences.getInt(AppConstants.voteCountSinceInterstitialKey) ?? 0) +
        1;
    await _preferences.setInt(
      AppConstants.voteCountSinceInterstitialKey,
      count,
    );
    _refreshInterstitialEligibility();
  }

  Future<bool> maybeShowInterstitial() async {
    if (!isConfigured.value) {
      return false;
    }

    _refreshInterstitialEligibility();
    if (!canShowInterstitial.value || _interstitialAd == null) {
      return false;
    }

    final completer = Completer<bool>();
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) async {
        ad.dispose();
        _interstitialAd = null;
        await _markInterstitialShown();
        await preloadInterstitial();
        completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitialAd = null;
        completer.complete(false);
      },
    );
    _interstitialAd!.show();
    return completer.future;
  }

  Future<void> _markInterstitialShown() async {
    await _preferences.setInt(AppConstants.voteCountSinceInterstitialKey, 0);
    await _preferences.setInt(
      AppConstants.interstitialDailyCountKey,
      (_preferences.getInt(AppConstants.interstitialDailyCountKey) ?? 0) + 1,
    );
    await _preferences.setString(
      AppConstants.lastInterstitialShownAtKey,
      DateTime.now().toIso8601String(),
    );
    _refreshInterstitialEligibility();
  }

  void _refreshInterstitialEligibility() {
    if (!isConfigured.value) {
      canShowInterstitial.value = false;
      return;
    }

    final voteCount =
        _preferences.getInt(AppConstants.voteCountSinceInterstitialKey) ?? 0;
    final dailyCount =
        _preferences.getInt(AppConstants.interstitialDailyCountKey) ?? 0;
    final lastShownRaw = _preferences.getString(
      AppConstants.lastInterstitialShownAtKey,
    );
    final lastShownAt = lastShownRaw == null
        ? null
        : DateTime.tryParse(lastShownRaw);
    final cooldownSatisfied =
        lastShownAt == null ||
        DateTime.now().difference(lastShownAt).inMinutes >=
            AppConstants.interstitialCooldownMinutes;
    canShowInterstitial.value =
        voteCount >= AppConstants.interstitialVoteThreshold &&
        dailyCount < AppConstants.maxInterstitialsPerDay &&
        cooldownSatisfied &&
        _interstitialAd != null;
  }

  bool get _hasNativeAppId {
    if (Platform.isIOS) {
      return AppConstants.admobIosAppId.trim().isNotEmpty;
    }
    if (Platform.isAndroid) {
      return AppConstants.admobAndroidAppId.trim().isNotEmpty;
    }
    return false;
  }

  String get _interstitialAdUnitId {
    if (!AppConstants.isProduction) {
      return AppConstants.testInterstitialAdUnitId;
    }
    if (Platform.isIOS) {
      return AppConstants.admobIosInterstitialId;
    }
    return AppConstants.admobAndroidInterstitialId;
  }

  String get _nativeAdUnitId {
    if (!AppConstants.isProduction) {
      return AppConstants.testNativeAdUnitId;
    }
    if (Platform.isIOS) {
      return AppConstants.admobIosNativeId;
    }
    return AppConstants.admobAndroidNativeId;
  }

  @override
  void onClose() {
    for (final nativeAd in _nativeAds) {
      nativeAd.dispose();
    }
    _interstitialAd?.dispose();
    super.onClose();
  }
}
