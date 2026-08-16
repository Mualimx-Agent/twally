import 'package:flutter/foundation.dart';

@immutable
class MenuItemModel {
  final String id;
  final String restaurantId;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String category; // appetizer, main, dessert, drink, side
  final double price;
  final String? imageUrl;
  final bool isAvailable;
  final bool isPopular;
  final int preparationTimeMin;

  MenuItemModel({
    required this.id,
    required this.restaurantId,
    this.nameAr = '',
    this.nameEn = '',
    this.descriptionAr = '',
    this.category = 'main',
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
    this.isPopular = false,
    this.preparationTimeMin = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'restaurant_id': restaurantId,
        'name_ar': nameAr,
        'name_en': nameEn,
        'description_ar': descriptionAr,
        'category': category,
        'price': price,
        'image_url': imageUrl,
        'is_available': isAvailable,
        'is_popular': isPopular,
        'preparation_time_min': preparationTimeMin,
      };

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
        id: json['id'] ?? '',
        restaurantId: json['restaurant_id'] ?? '',
        nameAr: json['name_ar'] ?? '',
        nameEn: json['name_en'] ?? '',
        descriptionAr: json['description_ar'] ?? '',
        category: json['category'] ?? 'main',
        price: (json['price'] ?? 0).toDouble(),
        imageUrl: json['image_url'],
        isAvailable: json['is_available'] ?? true,
        isPopular: json['is_popular'] ?? false,
        preparationTimeMin: json['preparation_time_min'] ?? 0,
      );

  MenuItemModel copyWith({
    String? id,
    String? restaurantId,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? category,
    double? price,
    String? imageUrl,
    bool? isAvailable,
    bool? isPopular,
    int? preparationTimeMin,
  }) =>
      MenuItemModel(
        id: id ?? this.id,
        restaurantId: restaurantId ?? this.restaurantId,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        descriptionAr: descriptionAr ?? this.descriptionAr,
        category: category ?? this.category,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isAvailable: isAvailable ?? this.isAvailable,
        isPopular: isPopular ?? this.isPopular,
        preparationTimeMin: preparationTimeMin ?? this.preparationTimeMin,
      );
}