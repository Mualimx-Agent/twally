class UserModel {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final List<UserAddress> addresses;
  final List<String> favorites;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fcmToken;
  final String languagePreference;
  final String? referralCode;
  final String? referredBy;

  UserModel({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.addresses = const [],
    this.favorites = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.fcmToken,
    this.languagePreference = 'ar',
    this.referralCode,
    this.referredBy,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        'email': email,
        'addresses': addresses.map((a) => a.toJson()).toList(),
        'favorites': favorites,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'fcm_token': fcmToken,
        'language_preference': languagePreference,
        'referral_code': referralCode,
        'referred_by': referredBy,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        phone: json['phone'] ?? '',
        name: json['name'] ?? '',
        email: json['email'],
        addresses: (json['addresses'] as List?)
                ?.map((a) => UserAddress.fromJson(a))
                .toList() ??
            [],
        favorites: List<String>.from(json['favorites'] ?? []),
        createdAt: DateTime.tryParse(json['created_at'] ?? ''),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
        fcmToken: json['fcm_token'],
        languagePreference: json['language_preference'] ?? 'ar',
        referralCode: json['referral_code'],
        referredBy: json['referred_by'],
      );

  UserModel copyWith({
    String? id,
    String? phone,
    String? name,
    String? email,
    List<UserAddress>? addresses,
    List<String>? favorites,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fcmToken,
    String? languagePreference,
    String? referralCode,
    String? referredBy,
  }) =>
      UserModel(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        name: name ?? this.name,
        email: email ?? this.email,
        addresses: addresses ?? this.addresses,
        favorites: favorites ?? this.favorites,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        fcmToken: fcmToken ?? this.fcmToken,
        languagePreference: languagePreference ?? this.languagePreference,
        referralCode: referralCode ?? this.referralCode,
        referredBy: referredBy ?? this.referredBy,
      );
}

class UserAddress {
  final String id;
  final String label;
  final String street;
  final String district;
  final String city;
  final double lat;
  final double lng;
  final bool isDefault;

  UserAddress({
    String? id,
    this.label = '',
    required this.street,
    required this.district,
    this.city = 'Khartoum',
    required this.lat,
    required this.lng,
    this.isDefault = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'street': street,
        'district': district,
        'city': city,
        'lat': lat,
        'lng': lng,
        'is_default': isDefault,
      };

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json['id'],
        label: json['label'] ?? '',
        street: json['street'] ?? '',
        district: json['district'] ?? '',
        city: json['city'] ?? 'Khartoum',
        lat: (json['lat'] ?? 0).toDouble(),
        lng: (json['lng'] ?? 0).toDouble(),
        isDefault: json['is_default'] ?? false,
      );

  UserAddress copyWith({
    String? id,
    String? label,
    String? street,
    String? district,
    String? city,
    double? lat,
    double? lng,
    bool? isDefault,
  }) =>
      UserAddress(
        id: id ?? this.id,
        label: label ?? this.label,
        street: street ?? this.street,
        district: district ?? this.district,
        city: city ?? this.city,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        isDefault: isDefault ?? this.isDefault,
      );
}