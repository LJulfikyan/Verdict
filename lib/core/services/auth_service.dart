import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import 'debug_logger.dart';

class AuthService extends GetxService with ChangeNotifier {
  AuthService({
    required AuthRepository repository,
    required UserRepository userRepository,
  }) : _repository = repository,
       _userRepository = userRepository;

  final AuthRepository _repository;
  final UserRepository _userRepository;

  final Rxn<User> _currentUser = Rxn<User>();
  StreamSubscription<User?>? _subscription;

  User? get currentUser => _currentUser.value;
  bool get isAuthenticated => _currentUser.value != null;
  bool get isGuest => _currentUser.value?.isAnonymous ?? false;

  Future<AuthService> init() async {
    DebugLogger.logInfo(
      module: 'Auth',
      className: 'AuthService',
      method: 'init',
      message: 'Initializing auth service',
    );
    await _repository.initializeGoogleSignIn();
    _subscription = _repository.authStateChanges().listen((user) async {
      _currentUser.value = user;
      if (user != null) {
        await _userRepository.createOrUpdateFromAuthUser(user);
        await _userRepository.updateLastSeen(user.uid);
      }
      DebugLogger.logState(
        module: 'Auth',
        className: 'AuthService',
        method: 'authStateChanges.listen',
        state: 'currentUser',
        to: user?.uid,
        additionalDetails: {'isAnonymous': user?.isAnonymous},
      );
      notifyListeners();
    });
    _currentUser.value = _repository.currentUser;
    if (_currentUser.value != null) {
      await _userRepository.createOrUpdateFromAuthUser(_currentUser.value!);
      await _userRepository.updateLastSeen(_currentUser.value!.uid);
    }
    DebugLogger.logInfo(
      module: 'Auth',
      className: 'AuthService',
      method: 'init',
      message: 'Auth service ready',
      additionalDetails: {
        'currentUser': _currentUser.value?.uid,
        'isAuthenticated': isAuthenticated,
      },
    );
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
