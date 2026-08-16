import 'package:flutter/foundation.dart';

@immutable
class OrderItem {
  final String menuItemId;
  final String nameAr;
  final int quantity;
  final double price;
  final double subtotal;

  OrderItem({
    required this.menuItemId,
    this.nameAr = '',
    required this.quantity,
    required this.price,
    this.subtotal = 0,
  });

  Map<String, dynamic> toJson() => {
        'menu_item_id': menuItemId,
        'name_ar': nameAr,
        'quantity': quantity,
        'price': price,
        'subtotal': subtotal,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        menuItemId: json['menu_item_id'] ?? '',
        nameAr: json['name_ar'] ?? '',
        quantity: json['quantity'] ?? 0,
        price: (json['price'] ?? 0).toDouble(),
        subtotal: (json['subtotal'] ?? 0).toDouble(),
      );

  OrderItem copyWith({
    String? menuItemId,
    String? nameAr,
    int? quantity,
    double? price,
    double? subtotal,
  }) =>
      OrderItem(
        menuItemId: menuItemId ?? this.menuItemId,
        nameAr: nameAr ?? this.nameAr,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        subtotal: subtotal ?? this.subtotal,
      );
}

@immutable
class OrderAddress {
  final String street;
  final String district;
  final String city;
  final double lat;
  final double lng;
  final String? notes;

  OrderAddress({
    required this.street,
    required this.district,
    this.city = 'Khartoum',
    this.lat = 0,
    this.lng = 0,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'street': street,
        'district': district,
        'city': city,
        'lat': lat,
        'lng': lng,
        'notes': notes,
      };

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
        street: json['street'] ?? '',
        district: json['district'] ?? '',
        city: json['city'] ?? 'Khartoum',
        lat: (json['lat'] ?? 0).toDouble(),
        lng: (json['lng'] ?? 0).toDouble(),
        notes: json['notes'],
      );

  OrderAddress copyWith({
    String? street,
    String? district,
    String? city,
    double? lat,
    double? lng,
    String? notes,
  }) =>
      OrderAddress(
        street: street ?? this.street,
        district: district ?? this.district,
        city: city ?? this.city,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        notes: notes ?? this.notes,
      );
}

@immutable
class OrderModel {
  final String id;
  final String orderNumber; // format: TW-YYYYMMDD-XXXX
  final String userId;
  final String restaurantId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;
  final String paymentMethod; // cod, mobile_money
  final String paymentStatus; // pending, paid, failed, refunded
  final String orderStatus; // pending, confirmed, preparing, ready, delivering, completed, cancelled
  final OrderAddress deliveryAddress;
  final String customerPhone;
  final String customerName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? cancellationReason;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.restaurantId,
    this.items = const [],
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.serviceFee = 0,
    this.total = 0,
    this.paymentMethod = 'cod',
    this.paymentStatus = 'pending',
    this.orderStatus = 'pending',
    required this.deliveryAddress,
    required this.customerPhone,
    this.customerName = '',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.cancellationReason,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'user_id': userId,
        'restaurant_id': restaurantId,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'delivery_fee': deliveryFee,
        'service_fee': serviceFee,
        'total': total,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'order_status': orderStatus,
        'delivery_address': deliveryAddress.toJson(),
        'customer_phone': customerPhone,
        'customer_name': customerName,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'estimated_delivery_time': estimatedDeliveryTime?.toIso8601String(),
        'actual_delivery_time': actualDeliveryTime?.toIso8601String(),
        'cancellation_reason': cancellationReason,
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] ?? '',
        orderNumber: json['order_number'] ?? '',
        userId: json['user_id'] ?? '',
        restaurantId: json['restaurant_id'] ?? '',
        items: (json['items'] as List?)
                ?.map((i) => OrderItem.fromJson(i as Map<String, dynamic>))
                .toList() ??
            [],
        subtotal: (json['subtotal'] ?? 0).toDouble(),
        deliveryFee: (json['delivery_fee'] ?? 0).toDouble(),
        serviceFee: (json['service_fee'] ?? 0).toDouble(),
        total: (json['total'] ?? 0).toDouble(),
        paymentMethod: json['payment_method'] ?? 'cod',
        paymentStatus: json['payment_status'] ?? 'pending',
        orderStatus: json['order_status'] ?? 'pending',
        deliveryAddress: OrderAddress.fromJson(
            json['delivery_address'] as Map<String, dynamic>? ?? {}),
        customerPhone: json['customer_phone'] ?? '',
        customerName: json['customer_name'] ?? '',
        createdAt: DateTime.tryParse(json['created_at'] ?? ''),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
        estimatedDeliveryTime:
            DateTime.tryParse(json['estimated_delivery_time'] ?? ''),
        actualDeliveryTime:
            DateTime.tryParse(json['actual_delivery_time'] ?? ''),
        cancellationReason: json['cancellation_reason'],
      );

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? userId,
    String? restaurantId,
    List<OrderItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? serviceFee,
    double? total,
    String? paymentMethod,
    String? paymentStatus,
    String? orderStatus,
    OrderAddress? deliveryAddress,
    String? customerPhone,
    String? customerName,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? cancellationReason,
  }) =>
      OrderModel(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        userId: userId ?? this.userId,
        restaurantId: restaurantId ?? this.restaurantId,
        items: items ?? this.items,
        subtotal: subtotal ?? this.subtotal,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        serviceFee: serviceFee ?? this.serviceFee,
        total: total ?? this.total,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        orderStatus: orderStatus ?? this.orderStatus,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        customerPhone: customerPhone ?? this.customerPhone,
        customerName: customerName ?? this.customerName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        estimatedDeliveryTime:
            estimatedDeliveryTime ?? this.estimatedDeliveryTime,
        actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
        cancellationReason: cancellationReason ?? this.cancellationReason,
      );
}