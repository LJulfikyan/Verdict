import 'package:equatable/equatable.dart';

class BoostModel extends Equatable {
  const BoostModel({
    required this.caseId,
    required this.planId,
    required this.multiplier,
    required this.expiresAt,
  });

  final String caseId;
  final String planId;
  final int multiplier;
  final DateTime expiresAt;

  @override
  List<Object?> get props => [caseId, planId, multiplier, expiresAt];
}
