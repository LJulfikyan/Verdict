import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/constants/app_constants.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepository {
  AuthRepository({required FirebaseAuthDataSource dataSource})
    : _dataSource = dataSource;

  final FirebaseAuthDataSource _dataSource;
  bool _googleInitialized = false;

  User? get currentUser => _dataSource.currentUser;
  Stream<User?> authStateChanges() => _dataSource.authStateChanges();

  Future<UserCredential> signInAnonymously() => _dataSource.signInAnonymously();

  Future<void> signOut() => _dataSource.signOut();

  Future<void> deleteAccount() => _dataSource.deleteCurrentUser();

  Future<void> initializeGoogleSignIn() async {
    if (_googleInitialized) {
      return;
    }

    await GoogleSignIn.instance.initialize(
      clientId: AppConstants.googleWebClientId.isEmpty
          ? null
          : AppConstants.googleWebClientId,
      serverClientId: AppConstants.googleServerClientId.isEmpty
          ? null
          : AppConstants.googleServerClientId,
    );

    _googleInitialized = true;
  }

  Future<void> signInWithGoogle() async {
    await initializeGoogleSignIn();

    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      throw UnsupportedError(
        'Google Sign-In is not supported on this platform.',
      );
    }

    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;

    if (googleAuth.idToken == null) {
      throw StateError('Google Sign-In did not return an ID token.');
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    await _dataSource.signInWithCredential(credential);
  }

  Future<void> signInWithApple() async {
    final provider = AppleAuthProvider()..addScope('email');
    await _dataSource.signInWithProvider(provider);
  }
}
