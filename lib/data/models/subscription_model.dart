import 'package:equatable/equatable.dart';

class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    required this.planId,
    required this.title,
    required this.priceLabel,
    required this.isActive,
  });

  final String planId;
  final String title;
  final String priceLabel;
  final bool isActive;

  @override
  List<Object?> get props => [planId, title, priceLabel, isActive];
}
