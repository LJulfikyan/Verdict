import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/premium_service.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  ProfileController({
    required AuthService authService,
    required PremiumService premiumService,
  }) : _authService = authService,
       _premiumService = premiumService;

  final AuthService _authService;
  final PremiumService _premiumService;

  final Rxn<UserModel> profile = Rxn<UserModel>();
  final RxMap<String, int> statistics = <String, int>{}.obs;
  final RxList<String> savedCases = <String>[].obs;
  final RxBool isLoading = false.obs;

  bool get isPremium => _premiumService.isPremium;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      return;
    }
    profile.value = UserModel(
      id: user.uid,
      isGuest: user.isAnonymous,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      premium: _premiumService.isPremium,
      createdAt: user.metadata.creationTime,
    );
  }
}
