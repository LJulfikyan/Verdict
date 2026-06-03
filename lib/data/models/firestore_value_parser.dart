import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? parseFirestoreDate(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }
  if (value is Timestamp) {
    return value.toDate();
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
