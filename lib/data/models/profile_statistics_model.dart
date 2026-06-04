import 'package:equatable/equatable.dart';

class ProfileStatisticsModel extends Equatable {
  const ProfileStatisticsModel({
    required this.casesPosted,
    required this.votesReceived,
    required this.savedCasesCount,
    required this.agreementScore,
  });

  final int casesPosted;
  final int votesReceived;
  final int savedCasesCount;
  final int agreementScore;

  const ProfileStatisticsModel.empty()
    : casesPosted = 0,
      votesReceived = 0,
      savedCasesCount = 0,
      agreementScore = 0;

  @override
  List<Object?> get props => [
    casesPosted,
    votesReceived,
    savedCasesCount,
    agreementScore,
  ];
}
