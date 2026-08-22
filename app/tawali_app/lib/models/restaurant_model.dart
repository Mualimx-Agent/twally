import 'package:flutter/foundation.dart';

@immutable
class OpeningHours {
  final String open;
  final String close;

  OpeningHours({
    required this.open,
    required this.close,
  });

  Map<String, dynamic> toJson() => {
        'open': open,
        'close': close,
      };

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
        open: json['open'] ?? '',
        close: json['close'] ?? '',
      );

  OpeningHours copyWith({
    String? open,
    String? close,
  }) =>
      OpeningHours(
        open: open ?? this.open,
        close: close ?? this.close,
      );
}

@immutable
class RestaurantModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String category; // sudanese, middle_eastern, fast_food, pizza, asian, dessert, cafe, other
  final String phone;
  final String? whatsapp;
  final String address;
  final String district;
  final String city; // khartoum, omburman, bahri, port_sudan
  final double lat;
  final double lng;
  final String? logoUrl;
  final String? coverImageUrl;
  final double rating;
  final int reviewCount;
  final double deliveryFee;
  final double minOrder;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final Map<String, OpeningHours> openingHours;
  final bool isActive;
  final bool isFeatured;
  final bool acceptsCod;
  final bool acceptsMobileMoney;
  final DateTime createdAt;
  final DateTime updatedAt;

  RestaurantModel({
    required this.id,
    this.nameAr = '',
    this.nameEn = '',
    this.descriptionAr = '',
    this.category = 'other',
    required this.phone,
    this.whatsapp,
    required this.address,
    required this.district,
    this.city = 'Khartoum',
    this.lat = 0,
    this.lng = 0,
    this.logoUrl,
    this.coverImageUrl,
    this.rating = 0,
    this.reviewCount = 0,
    this.deliveryFee = 0,
    this.minOrder = 0,
    this.deliveryTimeMin = 0,
    this.deliveryTimeMax = 0,
    this.openingHours = const {},
    this.isActive = true,
    this.isFeatured = false,
    this.acceptsCod = true,
    this.acceptsMobileMoney = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_ar': nameAr,
        'name_en': nameEn,
        'description_ar': descriptionAr,
        'category': category,
        'phone': phone,
        'whatsapp': whatsapp,
        'address': address,
        'district': district,
        'city': city,
        'lat': lat,
        'lng': lng,
        'logo_url': logoUrl,
        'cover_image_url': coverImageUrl,
        'rating': rating,
        'review_count': reviewCount,
        'delivery_fee': deliveryFee,
        'min_order': minOrder,
        'delivery_time_min': deliveryTimeMin,
        'delivery_time_max': deliveryTimeMax,
        'opening_hours':
            openingHours.map((k, v) => MapEntry(k, v.toJson())),
        'is_active': isActive,
        'is_featured': isFeatured,
        'accepts_cod': acceptsCod,
        'accepts_mobile_money': acceptsMobileMoney,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
        id: json['id'] ?? '',
        nameAr: json['name_ar'] ?? '',
        nameEn: json['name_en'] ?? '',
        descriptionAr: json['description_ar'] ?? '',
        category: json['category'] ?? 'other',
        phone: json['phone'] ?? '',
        whatsapp: json['whatsapp'],
        address: json['address'] ?? '',
        district: json['district'] ?? '',
        city: json['city'] ?? 'Khartoum',
        lat: (json['lat'] ?? 0).toDouble(),
        lng: (json['lng'] ?? 0).toDouble(),
        logoUrl: json['logo_url'],
        coverImageUrl: json['cover_image_url'],
        rating: (json['rating'] ?? 0).toDouble(),
        reviewCount: json['review_count'] ?? 0,
        deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
        minOrder: (json['min_order'] ?? 0).toDouble(),
        deliveryTimeMin: json['delivery_time_min'] ?? 0,
        deliveryTimeMax: json['delivery_time_max'] ?? 0,
        openingHours: (json['opening_hours'] as Map<String, dynamic>?)
                ?.map((k, v) =>
                    MapEntry(k, OpeningHours.fromJson(v as Map<String, dynamic>))) ??
            {},
        isActive: json['is_active'] ?? true,
        isFeatured: json['is_featured'] ?? false,
        acceptsCod: json['accepts_cod'] ?? true,
        acceptsMobileMoney: json['accepts_mobile_money'] ?? true,
        createdAt: DateTime.tryParse(json['created_at'] ?? ''),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      );

  RestaurantModel copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? category,
    String? phone,
    String? whatsapp,
    String? address,
    String? district,
    String? city,
    double? lat,
    double? lng,
    String? logoUrl,
    String? coverImageUrl,
    double? rating,
    int? reviewCount,
    double? deliveryFee,
    double? minOrder,
    int? deliveryTimeMin,
    int? deliveryTimeMax,
    Map<String, OpeningHours>? openingHours,
    bool? isActive,
    bool? isFeatured,
    bool? acceptsCod,
    bool? acceptsMobileMoney,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      RestaurantModel(
        id: id ?? this.id,
        nameAr: nameAr ?? this.nameAr,
        nameEn: nameEn ?? this.nameEn,
        descriptionAr: descriptionAr ?? this.descriptionAr,
        category: category ?? this.category,
        phone: phone ?? this.phone,
        whatsapp: whatsapp ?? this.whatsapp,
        address: address ?? this.address,
        district: district ?? this.district,
        city: city ?? this.city,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        logoUrl: logoUrl ?? this.logoUrl,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        minOrder: minOrder ?? this.minOrder,
        deliveryTimeMin: deliveryTimeMin ?? this.deliveryTimeMin,
        deliveryTimeMax: deliveryTimeMax ?? this.deliveryTimeMax,
        openingHours: openingHours ?? this.openingHours,
        isActive: isActive ?? this.isActive,
        isFeatured: isFeatured ?? this.isFeatured,
        acceptsCod: acceptsCod ?? this.acceptsCod,
        acceptsMobileMoney: acceptsMobileMoney ?? this.acceptsMobileMoney,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}