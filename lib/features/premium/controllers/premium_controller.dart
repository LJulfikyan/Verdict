import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/errors.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../../core/services/debug_logger.dart';
import '../../../core/services/premium_service.dart';

class PremiumController extends GetxController {
  PremiumController({required PremiumService premiumService})
    : _premiumService = premiumService;

  final PremiumService _premiumService;

  final RxBool isLoading = false.obs;
  final RxBool isRestoring = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedPackageId = ''.obs;

  bool get isPremium => _premiumService.isPremium;
  bool get isReady => _premiumService.isReady;
  Package? get monthlyPackage => _premiumService.monthlyPackage;
  Package? get yearlyPackage => _premiumService.yearlyPackage;
  Package? get selectedPackage {
    final selectedId = selectedPackageId.value;
    if (monthlyPackage?.identifier == selectedId) {
      return monthlyPackage;
    }
    if (yearlyPackage?.identifier == selectedId) {
      return yearlyPackage;
    }
    return monthlyPackage ?? yearlyPackage;
  }

  @override
  void onInit() {
    super.onInit();
    _selectDefaultPackage();
  }

  void selectPackage(Package package) {
    selectedPackageId.value = package.identifier;
  }

  Future<void> purchaseSelected() async {
    final package = selectedPackage;
    if (package == null) {
      errorMessage.value = 'No subscription plans are currently available.';
      return;
    }
    await _run(
      () => _premiumService.purchase(package),
      onCancelledMessage: '',
      onFailureMessage: 'Purchase failed. Please try again.',
    );
  }

  Future<void> restorePurchases() async {
    isRestoring.value = true;
    try {
      await _premiumService.restorePurchases();
      errorMessage.value = '';
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'RevenueCat',
        className: 'PremiumController',
        method: 'restorePurchases',
        error: error,
        stackTrace: stackTrace,
      );
      errorMessage.value = 'Restore failed. Please try again.';
    } finally {
      isRestoring.value = false;
    }
  }

  Future<void> _run(
    Future<dynamic> Function() action, {
    required String onCancelledMessage,
    required String onFailureMessage,
  }) async {
    isLoading.value = true;
    try {
      errorMessage.value = '';
      await action();
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'RevenueCat',
        className: 'PremiumController',
        method: '_run',
        error: error,
        stackTrace: stackTrace,
      );
      final code = error is PlatformException
          ? PurchasesErrorHelper.getErrorCode(error)
          : null;
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        errorMessage.value = onCancelledMessage;
      } else {
        errorMessage.value = onFailureMessage;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _selectDefaultPackage() {
    if (selectedPackageId.value.isNotEmpty &&
        (selectedPackage?.identifier == selectedPackageId.value)) {
      return;
    }
    selectedPackageId.value =
        yearlyPackage?.identifier ?? monthlyPackage?.identifier ?? '';
  }
}
