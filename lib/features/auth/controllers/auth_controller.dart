import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';

class AuthController extends GetxController {
  AuthController({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;

  final RxBool isLoading = false.obs;
  final RxBool isGuest = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _syncState();
    ever<bool>(isAuthenticated, (_) => _syncState());
  }

  void _syncState() {
    isGuest.value = _authService.isGuest;
    isAuthenticated.value = _authService.isAuthenticated;
  }

  Future<void> loginGoogle() => _run(_authService.loginGoogle);
  Future<void> loginApple() => _run(_authService.loginApple);
  Future<void> continueAsGuest() => _run(_authService.continueAsGuest);
  Future<void> logout() => _run(_authService.logout);
  Future<void> deleteAccount() => _run(_authService.deleteAccount);

  Future<void> _run(Future<dynamic> Function() action) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await action();
      _syncState();
    } catch (error) {
      errorMessage.value = _mapError(error);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  String _mapError(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('cancel')) {
      return 'Sign in was canceled.';
    }
    if (message.contains('not supported')) {
      return 'This sign-in method is not available on this device.';
    }
    if (message.contains('id token')) {
      return 'Sign in could not be verified. Please try again.';
    }
    return 'Unable to complete sign in right now.';
  }
}
