import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'case_model.dart';

class CaseFeedPage extends Equatable {
  const CaseFeedPage({
    required this.items,
    this.lastDocument,
    required this.hasMore,
  });

  final List<CaseModel> items;
  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
  final bool hasMore;

  @override
  List<Object?> get props => [items, lastDocument?.id, hasMore];
}
