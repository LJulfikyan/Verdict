import 'package:equatable/equatable.dart';

import 'firestore_value_parser.dart';

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.targetId,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final String targetId;
  final bool isRead;
  final DateTime? createdAt;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? targetId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NotificationModel.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    return NotificationModel(
      id: id,
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      type: map['type'] as String? ?? '',
      targetId: map['targetId'] as String? ?? '',
      isRead: map['isRead'] as bool? ?? false,
      createdAt: parseFirestoreDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'targetId': targetId,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    type,
    targetId,
    isRead,
    createdAt,
  ];
}
