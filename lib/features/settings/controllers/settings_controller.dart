import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;
  final RxBool caseActivityEnabled = true.obs;
  final RxBool trendingEnabled = true.obs;
  final RxBool premiumOffersEnabled = true.obs;
  final RxBool systemEnabled = true.obs;
}
