import 'package:get/get.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../../core/services/premium_service.dart';

class PremiumController extends GetxController {
  PremiumController({required PremiumService premiumService})
    : _premiumService = premiumService;

  final PremiumService _premiumService;

  final RxBool isLoading = false.obs;

  bool get isPremium => _premiumService.isPremium;

  Future<void> restorePurchases() => _run(_premiumService.restorePurchases);

  Future<void> purchase(Package package) =>
      _run(() => _premiumService.purchase(package));

  Future<void> _run(Future<dynamic> Function() action) async {
    isLoading.value = true;
    try {
      await action();
    } finally {
      isLoading.value = false;
    }
  }
}
