import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';

class AuthService extends GetxService with ChangeNotifier {
  AuthService({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  final Rxn<User> _currentUser = Rxn<User>();
  StreamSubscription<User?>? _subscription;

  User? get currentUser => _currentUser.value;
  bool get isAuthenticated => _currentUser.value != null;
  bool get isGuest => _currentUser.value?.isAnonymous ?? false;

  Future<AuthService> init() async {
    await _repository.initializeGoogleSignIn();
    _subscription = _repository.authStateChanges().listen((user) {
      _currentUser.value = user;
      notifyListeners();
    });
    _currentUser.value = _repository.currentUser;
    return this;
  }

  Future<UserCredential> continueAsGuest() => _repository.signInAnonymously();

  Future<void> logout() => _repository.signOut();

  Future<void> deleteAccount() => _repository.deleteAccount();

  Future<void> loginGoogle() => _repository.signInWithGoogle();

  Future<void> loginApple() => _repository.signInWithApple();

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
