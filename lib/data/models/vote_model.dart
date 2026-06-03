import 'package:equatable/equatable.dart';

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
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caseId': caseId,
      'userId': userId,
      'option': option,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [caseId, userId, option, createdAt];
}
