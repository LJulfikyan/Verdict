import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/premium_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  ProfileController({
    required AuthService authService,
    required PremiumService premiumService,
    required UserRepository userRepository,
  }) : _authService = authService,
       _premiumService = premiumService,
       _userRepository = userRepository;

  final AuthService _authService;
  final PremiumService _premiumService;
  final UserRepository _userRepository;

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
    final storedProfile = await _userRepository.getUser(user.uid);
    profile.value =
        (storedProfile ??
                UserModel(
                  id: user.uid,
                  isGuest: user.isAnonymous,
                  provider: user.providerData.isNotEmpty
                      ? user.providerData.first.providerId
                      : user.isAnonymous
                      ? 'guest'
                      : 'unknown',
                  displayName: user.displayName,
                  photoUrl: user.photoURL,
                  premium: _premiumService.isPremium,
                  createdAt: user.metadata.creationTime,
                ))
            .copyWith(premium: _premiumService.isPremium);
  }
}
