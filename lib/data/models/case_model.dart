import 'package:equatable/equatable.dart';

class CaseModel extends Equatable {
  const CaseModel({
    required this.id,
    required this.authorId,
    required this.relationshipType,
    required this.category,
    required this.description,
    required this.question,
    required this.status,
    required this.votesCount,
    required this.reportsCount,
    required this.results,
    this.hotScore = 0,
    this.userVote,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String authorId;
  final String relationshipType;
  final String category;
  final String description;
  final String question;
  final String status;
  final int votesCount;
  final int reportsCount;
  final Map<String, int> results;
  final double hotScore;
  final String? userVote;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isActive => status == 'active';

  CaseModel copyWith({
    String? id,
    String? authorId,
    String? relationshipType,
    String? category,
    String? description,
    String? question,
    String? status,
    int? votesCount,
    int? reportsCount,
    Map<String, int>? results,
    double? hotScore,
    String? userVote,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CaseModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      relationshipType: relationshipType ?? this.relationshipType,
      category: category ?? this.category,
      description: description ?? this.description,
      question: question ?? this.question,
      status: status ?? this.status,
      votesCount: votesCount ?? this.votesCount,
      reportsCount: reportsCount ?? this.reportsCount,
      results: results ?? this.results,
      hotScore: hotScore ?? this.hotScore,
      userVote: userVote ?? this.userVote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory CaseModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return CaseModel(
      id: id,
      authorId: map['authorId'] as String? ?? '',
      relationshipType: map['relationshipType'] as String? ?? '',
      category: map['category'] as String? ?? '',
      description: map['description'] as String? ?? '',
      question: map['question'] as String? ?? '',
      status: map['status'] as String? ?? 'active',
      votesCount: map['votesCount'] as int? ?? 0,
      reportsCount: map['reportsCount'] as int? ?? 0,
      results: Map<String, int>.from(map['results'] as Map? ?? const {}),
      hotScore: (map['hotScore'] as num? ?? 0).toDouble(),
      userVote: map['userVote'] as String?,
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'relationshipType': relationshipType,
      'category': category,
      'description': description,
      'question': question,
      'status': status,
      'votesCount': votesCount,
      'reportsCount': reportsCount,
      'results': results,
      'hotScore': hotScore,
      'userVote': userVote,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    authorId,
    relationshipType,
    category,
    description,
    question,
    status,
    votesCount,
    reportsCount,
    results,
    hotScore,
    userVote,
    createdAt,
    updatedAt,
  ];
}

DateTime? _toDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }
  if (value == null) {
    return null;
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  final seconds = (value as dynamic).seconds;
  if (seconds is int) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }
  return null;
}
