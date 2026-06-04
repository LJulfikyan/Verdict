import 'package:equatable/equatable.dart';

class VoteSubmissionResult extends Equatable {
  const VoteSubmissionResult({
    required this.results,
    required this.votesCount,
    required this.winnerOption,
    required this.hotScore,
  });

  final Map<String, int> results;
  final int votesCount;
  final String winnerOption;
  final double hotScore;

  factory VoteSubmissionResult.fromMap(Map<String, dynamic> map) {
    return VoteSubmissionResult(
      results: Map<String, int>.from(map['results'] as Map? ?? const {}),
      votesCount: map['votesCount'] as int? ?? 0,
      winnerOption: map['winnerOption'] as String? ?? '',
      hotScore: (map['hotScore'] as num? ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [results, votesCount, winnerOption, hotScore];
}
