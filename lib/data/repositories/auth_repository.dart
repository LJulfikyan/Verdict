import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/firebase_auth_datasource.dart';

class AuthRepository {
  AuthRepository({required FirebaseAuthDataSource dataSource})
    : _dataSource = dataSource;

  final FirebaseAuthDataSource _dataSource;

  User? get currentUser => _dataSource.currentUser;
  Stream<User?> authStateChanges() => _dataSource.authStateChanges();

  Future<UserCredential> signInAnonymously() => _dataSource.signInAnonymously();

  Future<void> signOut() => _dataSource.signOut();

  Future<void> deleteAccount() => _dataSource.deleteCurrentUser();

  Future<void> signInWithGoogle() {
    throw UnimplementedError(
      'Google sign-in integration belongs in the next auth implementation task.',
    );
  }

  Future<void> signInWithApple() {
    throw UnimplementedError(
      'Apple sign-in integration belongs in the next auth implementation task.',
    );
  }
}
