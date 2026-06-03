import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.targetRoute,
    this.isRead = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String targetRoute;
  final bool isRead;
  final DateTime? createdAt;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? targetRoute,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      targetRoute: targetRoute ?? this.targetRoute,
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
      targetRoute: map['targetRoute'] as String? ?? '',
      isRead: map['isRead'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'targetRoute': targetRoute,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, title, body, targetRoute, isRead, createdAt];
}
