import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.isGuest,
    this.displayName,
    this.photoUrl,
    this.country,
    this.premium = false,
    this.createdAt,
  });

  final String id;
  final bool isGuest;
  final String? displayName;
  final String? photoUrl;
  final String? country;
  final bool premium;
  final DateTime? createdAt;

  UserModel copyWith({
    String? id,
    bool? isGuest,
    String? displayName,
    String? photoUrl,
    String? country,
    bool? premium,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      isGuest: isGuest ?? this.isGuest,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      country: country ?? this.country,
      premium: premium ?? this.premium,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return UserModel(
      id: id,
      isGuest: map['isGuest'] as bool? ?? false,
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      country: map['country'] as String?,
      premium: map['premium'] as bool? ?? false,
      createdAt: _toDateTime(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isGuest': isGuest,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'country': country,
      'premium': premium,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    isGuest,
    displayName,
    photoUrl,
    country,
    premium,
    createdAt,
  ];
}

DateTime? _toDateTime(dynamic value) {
  if (value is DateTime) {
    return value;
  }
  if (value == null) {
    return null;
  }
  return DateTime.tryParse(value.toString());
}
