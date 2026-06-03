import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  const ReportModel({
    required this.caseId,
    required this.reason,
    required this.reporterId,
    this.createdAt,
  });

  final String caseId;
  final String reason;
  final String reporterId;
  final DateTime? createdAt;

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      caseId: map['caseId'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      reporterId: map['reporterId'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caseId': caseId,
      'reason': reason,
      'reporterId': reporterId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [caseId, reason, reporterId, createdAt];
}
