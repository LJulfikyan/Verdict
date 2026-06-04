import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/api_constants.dart';
import '../../core/services/debug_logger.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/functions_datasource.dart';
import '../models/case_feed_page.dart';
import '../models/case_model.dart';

class CaseRepository {
  CaseRepository({
    required FirebaseAuthDataSource authDataSource,
    required FirestoreDataSource firestoreDataSource,
    required FunctionsDataSource functionsDataSource,
  }) : _authDataSource = authDataSource,
       _firestoreDataSource = firestoreDataSource,
       _functionsDataSource = functionsDataSource;

  final FirebaseAuthDataSource _authDataSource;
  final FirestoreDataSource _firestoreDataSource;
  final FunctionsDataSource _functionsDataSource;

  Future<CaseFeedPage> getFeed({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 20,
    String? category,
    String? relationshipType,
  }) async {
    try {
      final snapshot = await _firestoreDataSource.fetchCases(
        startAfter: startAfter,
        limit: limit,
        category: category,
        relationshipType: relationshipType,
      );
      final items = snapshot.docs
          .map((doc) => CaseModel.fromMap(doc.data(), id: doc.id))
          .toList(growable: false);
      return CaseFeedPage(
        items: items,
        lastDocument: snapshot.docs.isEmpty ? null : snapshot.docs.last,
        hasMore: snapshot.docs.length == limit,
      );
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'CaseRepository',
        method: 'getFeed',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {
          'limit': limit,
          'category': category,
          'relationshipType': relationshipType,
        },
      );
      rethrow;
    }
  }

  Future<CaseModel?> getCaseById(String caseId) async {
    try {
      final snapshot = await _firestoreDataSource.getCase(caseId);
      final data = snapshot.data();
      if (!snapshot.exists || data == null) {
        DebugLogger.logInfo(
          module: 'Repository',
          className: 'CaseRepository',
          method: 'getCaseById',
          message: 'Case document not found',
          additionalDetails: {'caseId': caseId},
        );
        return null;
      }
      return CaseModel.fromMap(data, id: snapshot.id);
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'CaseRepository',
        method: 'getCaseById',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {'caseId': caseId},
      );
      rethrow;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchCase(String caseId) {
    return _firestoreDataSource.watchCase(caseId);
  }

  Future<String> createCase({
    required String relationshipType,
    required String category,
    required String description,
    required String question,
  }) async {
    try {
      final result = await _functionsDataSource.call(
        ApiConstants.createCase,
        parameters: {
          'relationshipType': relationshipType,
          'category': category,
          'description': description,
          'question': question,
        },
      );
      return result['caseId'] as String? ?? '';
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'CaseRepository',
        method: 'createCase',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> saveCase(String caseId) async {
    if (_authDataSource.currentUser == null) {
      throw StateError('User must be authenticated to save a case.');
    }
    try {
      await _functionsDataSource.call(
        ApiConstants.saveCase,
        parameters: {'caseId': caseId},
      );
    } catch (error, stackTrace) {
      DebugLogger.logError(
        module: 'Repository',
        className: 'CaseRepository',
        method: 'saveCase',
        error: error,
        stackTrace: stackTrace,
        additionalDetails: {'caseId': caseId},
      );
      rethrow;
    }
  }
}
