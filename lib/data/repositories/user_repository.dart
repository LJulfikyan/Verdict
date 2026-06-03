import 'package:firebase_auth/firebase_auth.dart';

import '../datasources/firestore_datasource.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository({required FirestoreDataSource firestoreDataSource})
    : _firestoreDataSource = firestoreDataSource;

  final FirestoreDataSource _firestoreDataSource;

  Future<UserModel?> getUser(String userId) async {
    final snapshot = await _firestoreDataSource.getUser(userId);
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }
    return UserModel.fromMap(data, id: snapshot.id);
  }

  Future<void> createOrUpdateFromAuthUser(User user) async {
    final provider = user.isAnonymous
        ? 'guest'
        : user.providerData.isNotEmpty
        ? user.providerData.first.providerId
        : 'unknown';

    await _firestoreDataSource.setUser(user.uid, {
      'id': user.uid,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'provider': provider,
      'premium': false,
      'createdAt': user.metadata.creationTime,
      'lastSeenAt': DateTime.now(),
      'casesCount': 0,
      'votesCount': 0,
      'savedCount': 0,
      'reportsCount': 0,
      'agreementScore': 0,
      'country': null,
      'gender': null,
      'ageRange': null,
      'isBanned': false,
    });
  }

  Future<void> updateLastSeen(String userId) {
    return _firestoreDataSource.updateUser(userId, {
      'lastSeenAt': DateTime.now(),
    });
  }

  Future<Set<String>> getSavedCaseIds(String userId) async {
    final snapshot = await _firestoreDataSource.fetchSavedCases(userId);
    return snapshot.docs.map((doc) => doc.id).toSet();
  }
}
