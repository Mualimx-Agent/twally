import 'package:flutter/foundation.dart';

@immutable
class ReviewModel {
  final String id;
  final String orderId;
  final String userId;
  final String restaurantId;
  final int rating; // 1-5
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.restaurantId,
    this.rating = 5,
    this.comment = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'user_id': userId,
        'restaurant_id': restaurantId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt.toIso8601String(),
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] ?? '',
        orderId: json['order_id'] ?? '',
        userId: json['user_id'] ?? '',
        restaurantId: json['restaurant_id'] ?? '',
        rating: json['rating'] ?? 5,
        comment: json['comment'] ?? '',
        createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      );

  ReviewModel copyWith({
    String? id,
    String? orderId,
    String? userId,
    String? restaurantId,
    int? rating,
    String? comment,
    DateTime? createdAt,
  }) =>
      ReviewModel(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        userId: userId ?? this.userId,
        restaurantId: restaurantId ?? this.restaurantId,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        createdAt: createdAt ?? this.createdAt,
      );
}