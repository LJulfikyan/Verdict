import 'package:purchases_flutter/purchases_flutter.dart';

class PremiumRepository {
  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();

  Future<Offerings> getOfferings() => Purchases.getOfferings();

  void addCustomerInfoUpdateListener(
    CustomerInfoUpdateListener listener,
  ) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  void removeCustomerInfoUpdateListener(
    CustomerInfoUpdateListener listener,
  ) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  Future<CustomerInfo> purchase(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }

  Future<CustomerInfo> restorePurchases() => Purchases.restorePurchases();
}
