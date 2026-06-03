import 'package:equatable/equatable.dart';

import 'firestore_value_parser.dart';

class VoteModel extends Equatable {
  const VoteModel({
    required this.caseId,
    required this.userId,
    required this.option,
    this.createdAt,
  });

  final String caseId;
  final String userId;
  final String option;
  final DateTime? createdAt;

  factory VoteModel.fromMap(Map<String, dynamic> map) {
    return VoteModel(
      caseId: map['caseId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      option: map['option'] as String? ?? '',
      createdAt: parseFirestoreDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caseId': caseId,
      'userId': userId,
      'option': option,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [caseId, userId, option, createdAt];
}
