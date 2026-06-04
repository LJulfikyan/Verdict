import 'dart:io';

import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../data/repositories/premium_repository.dart';
import '../constants/analytics_events.dart';
import 'analytics_service.dart';

class PremiumService extends GetxService {
  PremiumService({
    required PremiumRepository repository,
    required AnalyticsService analyticsService,
  }) : _repository = repository,
       _analyticsService = analyticsService;

  final PremiumRepository _repository;
  final AnalyticsService _analyticsService;
  CustomerInfoUpdateListener? _customerInfoListener;

  final Rxn<CustomerInfo> _customerInfo = Rxn<CustomerInfo>();
  final Rxn<Offerings> _offerings = Rxn<Offerings>();
  final RxBool _isReady = false.obs;

  CustomerInfo? get customerInfo => _customerInfo.value;
  Offerings? get offerings => _offerings.value;
  bool get isReady => _isReady.value;
  Package? get monthlyPackage => _packageByType(PackageType.monthly);
  Package? get yearlyPackage => _packageByType(PackageType.annual);
  bool get isPremium =>
      _customerInfo.value?.entitlements.active.containsKey('premium') ?? false;

  Future<PremiumService> init({required String apiKey}) async {
    if (apiKey.isNotEmpty && (Platform.isAndroid || Platform.isIOS)) {
      await Purchases.setLogLevel(LogLevel.warn);
      await Purchases.configure(PurchasesConfiguration(apiKey));
      _customerInfoListener = (customerInfo) {
        _customerInfo.value = customerInfo;
      };
      _repository.addCustomerInfoUpdateListener(_customerInfoListener!);
      await refresh();
    }
    _isReady.value = true;
    return this;
  }

  Future<void> refresh() async {
    _customerInfo.value = await _repository.getCustomerInfo();
    _offerings.value = await _repository.getOfferings();
  }

  Future<CustomerInfo> purchase(Package package) async {
    final info = await _repository.purchase(package);
    _customerInfo.value = info;
    _offerings.value = await _repository.getOfferings();
    await _analyticsService.logEvent(
      AnalyticsEvents.premiumPurchase,
      parameters: {'package_id': package.identifier},
    );
    return info;
  }

  Future<CustomerInfo> restorePurchases() async {
    final info = await _repository.restorePurchases();
    _customerInfo.value = info;
    _offerings.value = await _repository.getOfferings();
    return info;
  }

  Package? _packageByType(PackageType type) {
    final current = _offerings.value?.current;
    if (current == null) {
      return null;
    }
    for (final package in current.availablePackages) {
      if (package.packageType == type) {
        return package;
      }
    }
    return null;
  }

  @override
  void onClose() {
    if (_customerInfoListener != null) {
      _repository.removeCustomerInfoUpdateListener(_customerInfoListener!);
    }
    super.onClose();
  }
}
