import 'package:flutter/foundation.dart';

@immutable
class PromoCodeModel {
  final String id;
  final String code;
  final String descriptionAr;
  final String discountType; // percentage, fixed
  final double discountValue;
  final double minOrder;
  final double maxDiscount;
  final DateTime validFrom;
  final DateTime validUntil;
  final int usageLimit;
  final int usageCount;
  final bool isActive;

  PromoCodeModel({
    required this.id,
    required this.code,
    this.descriptionAr = '',
    required this.discountType,
    required this.discountValue,
    this.minOrder = 0,
    this.maxDiscount = 0,
    DateTime? validFrom,
    required this.validUntil,
    this.usageLimit = 0,
    this.usageCount = 0,
    this.isActive = true,
  }) : validFrom = validFrom ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'description_ar': descriptionAr,
        'discount_type': discountType,
        'discount_value': discountValue,
        'min_order': minOrder,
        'max_discount': maxDiscount,
        'valid_from': validFrom.toIso8601String(),
        'valid_until': validUntil.toIso8601String(),
        'usage_limit': usageLimit,
        'usage_count': usageCount,
        'is_active': isActive,
      };

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) => PromoCodeModel(
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        descriptionAr: json['description_ar'] ?? '',
        discountType: json['discount_type'] ?? 'percentage',
        discountValue: (json['discount_value'] ?? 0).toDouble(),
        minOrder: (json['min_order'] ?? 0).toDouble(),
        maxDiscount: (json['max_discount'] ?? 0).toDouble(),
        validFrom: DateTime.tryParse(json['valid_from'] ?? ''),
        validUntil: DateTime.tryParse(json['valid_until'] ?? '') ?? DateTime.now(),
        usageLimit: json['usage_limit'] ?? 0,
        usageCount: json['usage_count'] ?? 0,
        isActive: json['is_active'] ?? true,
      );

  PromoCodeModel copyWith({
    String? id,
    String? code,
    String? descriptionAr,
    String? discountType,
    double? discountValue,
    double? minOrder,
    double? maxDiscount,
    DateTime? validFrom,
    DateTime? validUntil,
    int? usageLimit,
    int? usageCount,
    bool? isActive,
  }) =>
      PromoCodeModel(
        id: id ?? this.id,
        code: code ?? this.code,
        descriptionAr: descriptionAr ?? this.descriptionAr,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        minOrder: minOrder ?? this.minOrder,
        maxDiscount: maxDiscount ?? this.maxDiscount,
        validFrom: validFrom ?? this.validFrom,
        validUntil: validUntil ?? this.validUntil,
        usageLimit: usageLimit ?? this.usageLimit,
        usageCount: usageCount ?? this.usageCount,
        isActive: isActive ?? this.isActive,
      );
}