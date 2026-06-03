import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/api_constants.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/functions_datasource.dart';
import '../models/case_feed_page.dart';
import '../models/case_model.dart';

class CaseRepository {
  CaseRepository({
    required FirestoreDataSource firestoreDataSource,
    required FunctionsDataSource functionsDataSource,
  }) : _firestoreDataSource = firestoreDataSource,
       _functionsDataSource = functionsDataSource;

  final FirestoreDataSource _firestoreDataSource;
  final FunctionsDataSource _functionsDataSource;

  Future<CaseFeedPage> getFeed({
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
    int limit = 20,
  }) async {
    final snapshot = await _firestoreDataSource.fetchCases(
      startAfter: startAfter,
      limit: limit,
    );
    final items = snapshot.docs
        .map((doc) => CaseModel.fromMap(doc.data(), id: doc.id))
        .toList(growable: false);
    return CaseFeedPage(
      items: items,
      lastDocument: snapshot.docs.isEmpty ? null : snapshot.docs.last,
      hasMore: snapshot.docs.length == limit,
    );
  }

  Future<String> createCase({
    required String relationshipType,
    required String category,
    required String description,
    required String question,
  }) async {
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
  }

  Future<void> saveCase(String caseId) async {
    await _functionsDataSource.call(
      ApiConstants.saveCase,
      parameters: {'caseId': caseId},
    );
  }
}
