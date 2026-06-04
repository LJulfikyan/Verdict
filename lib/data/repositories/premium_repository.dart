import 'package:purchases_flutter/purchases_flutter.dart';

import '../../core/services/debug_logger.dart';

class PremiumRepository {
  Future<CustomerInfo> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'RevenueCat',
        className: 'PremiumRepository',
        method: 'getCustomerInfo',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<Offerings> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'RevenueCat',
        className: 'PremiumRepository',
        method: 'getOfferings',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void addCustomerInfoUpdateListener(CustomerInfoUpdateListener listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  void removeCustomerInfoUpdateListener(CustomerInfoUpdateListener listener) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  Future<CustomerInfo> purchase(Package package) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return result.customerInfo;
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'RevenueCat',
        className: 'PremiumRepository',
        method: 'purchase',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {'packageId': package.identifier},
      );
      rethrow;
    }
  }

  Future<CustomerInfo> restorePurchases() async {
    try {
      return await Purchases.restorePurchases();
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'RevenueCat',
        className: 'PremiumRepository',
        method: 'restorePurchases',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
