import 'package:equatable/equatable.dart';

import 'firestore_value_parser.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.isGuest,
    required this.provider,
    this.displayName,
    this.photoUrl,
    this.country,
    this.gender,
    this.ageRange,
    this.premium = false,
    this.casesCount = 0,
    this.votesCount = 0,
    this.savedCount = 0,
    this.reportsCount = 0,
    this.agreementScore = 0,
    this.isBanned = false,
    this.createdAt,
    this.lastSeenAt,
  });

  final String id;
  final bool isGuest;
  final String provider;
  final String? displayName;
  final String? photoUrl;
  final String? country;
  final String? gender;
  final String? ageRange;
  final bool premium;
  final int casesCount;
  final int votesCount;
  final int savedCount;
  final int reportsCount;
  final int agreementScore;
  final bool isBanned;
  final DateTime? createdAt;
  final DateTime? lastSeenAt;

  UserModel copyWith({
    String? id,
    bool? isGuest,
    String? provider,
    String? displayName,
    String? photoUrl,
    String? country,
    String? gender,
    String? ageRange,
    bool? premium,
    int? casesCount,
    int? votesCount,
    int? savedCount,
    int? reportsCount,
    int? agreementScore,
    bool? isBanned,
    DateTime? createdAt,
    DateTime? lastSeenAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      isGuest: isGuest ?? this.isGuest,
      provider: provider ?? this.provider,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      premium: premium ?? this.premium,
      casesCount: casesCount ?? this.casesCount,
      votesCount: votesCount ?? this.votesCount,
      savedCount: savedCount ?? this.savedCount,
      reportsCount: reportsCount ?? this.reportsCount,
      agreementScore: agreementScore ?? this.agreementScore,
      isBanned: isBanned ?? this.isBanned,
      createdAt: createdAt ?? this.createdAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return UserModel(
      id: id,
      isGuest:
          ((map['provider'] as String?) ?? '') == 'guest' ||
          ((map['isGuest'] as bool?) ?? false),
      provider: map['provider'] as String? ?? 'unknown',
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      country: map['country'] as String?,
      gender: map['gender'] as String?,
      ageRange: map['ageRange'] as String?,
      premium: map['premium'] as bool? ?? false,
      casesCount: map['casesCount'] as int? ?? 0,
      votesCount: map['votesCount'] as int? ?? 0,
      savedCount: map['savedCount'] as int? ?? 0,
      reportsCount: map['reportsCount'] as int? ?? 0,
      agreementScore: map['agreementScore'] as int? ?? 0,
      isBanned: map['isBanned'] as bool? ?? false,
      createdAt: parseFirestoreDate(map['createdAt']),
      lastSeenAt: parseFirestoreDate(map['lastSeenAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isGuest': isGuest,
      'provider': provider,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'country': country,
      'gender': gender,
      'ageRange': ageRange,
      'premium': premium,
      'casesCount': casesCount,
      'votesCount': votesCount,
      'savedCount': savedCount,
      'reportsCount': reportsCount,
      'agreementScore': agreementScore,
      'isBanned': isBanned,
      'createdAt': createdAt,
      'lastSeenAt': lastSeenAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    isGuest,
    provider,
    displayName,
    photoUrl,
    country,
    gender,
    ageRange,
    premium,
    casesCount,
    votesCount,
    savedCount,
    reportsCount,
    agreementScore,
    isBanned,
    createdAt,
    lastSeenAt,
  ];
}
