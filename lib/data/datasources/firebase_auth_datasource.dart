import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/debug_logger.dart';

class FirebaseAuthDataSource {
  FirebaseAuthDataSource({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  FirebaseAuth get instance => _firebaseAuth;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInAnonymously() => _wrapAuthCall(
    'signInAnonymously',
    () => _firebaseAuth.signInAnonymously(),
  );

  Future<void> signOut() =>
      _wrapAuthCall('signOut', () => _firebaseAuth.signOut());

  Future<void> deleteCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _wrapAuthCall('deleteCurrentUser', () => user.delete());
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    return _wrapAuthCall(
      'signInWithCredential',
      () => _firebaseAuth.signInWithCredential(credential),
    );
  }

  Future<UserCredential> signInWithProvider(AuthProvider provider) {
    return _wrapAuthCall(
      'signInWithProvider',
      () => _firebaseAuth.signInWithProvider(provider),
    );
  }

  Future<T> _wrapAuthCall<T>(String method, Future<T> Function() action) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Auth',
        className: 'FirebaseAuthDataSource',
        method: method,
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
