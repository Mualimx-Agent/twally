class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Tawali';
  static const String appNameAr = 'طوالي';
  static const String sloganAr = 'جعان؟ طوالي';
  static const String sloganEn = 'Hungry? Tawali';
  static const String appVersion = '1.0.0';

  // Defaults
  static const String defaultCity = 'Khartoum';
  static const String defaultCountryCode = 'SD';
  static const String defaultCurrency = 'SDG';
  static const String defaultCurrencySymbol = 'ج.س';
  static const double defaultDeliveryFee = 3.0;
  static const double defaultMinOrder = 10.0;

  // Timings
  static const int splashDurationMs = 2000;
  static const int animationDurationMs = 300;
  static const int searchDebounceMs = 500;
  static const int maxOrderItems = 50;
  static const int nearbyRadiusKm = 10;

  // Firebase
  static const String firestoreRegion = 'europe-west1';

  // Collections
  static const String collectionUsers = 'users';
  static const String collectionRestaurants = 'restaurants';
  static const String collectionMenuItems = 'menu_items';
  static const String collectionOrders = 'orders';
  static const String collectionReviews = 'reviews';
  static const String collectionPromoCodes = 'promo_codes';

  // Storage paths
  static const String storageRestaurants = 'restaurants';
  static const String storageMenuItems = 'menu_items';
  static const String storageProfiles = 'profiles';

  // Order status
  static const List<String> orderStatuses = [
    'pending', 'confirmed', 'preparing', 'ready', 'delivering', 'completed', 'cancelled'
  ];

  // Payment methods
  static const String paymentCOD = 'cod';
  static const String paymentMobileMoney = 'mobile_money';

  // Restaurant categories
  static const Map<String, String> categories = {
    'sudanese': 'سوداني',
    'middle_eastern': 'شرق أوسطي',
    'fast_food': 'وجبات سريعة',
    'pizza': 'بيتزا',
    'asian': 'آسيوي',
    'dessert': 'حلويات',
    'cafe': 'مقهى',
    'other': 'أخرى',
  };

  // Menu categories
  static const Map<String, String> menuCategories = {
    'appetizer': 'مقبلات',
    'main': 'الوجبة الرئيسية',
    'dessert': 'حلويات',
    'drink': 'مشروبات',
    'side': 'إضافات',
  };

  // Shared Preferences keys
  static const String prefLanguage = 'language';
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefUserId = 'user_id';
  static const String prefFcmToken = 'fcm_token';

  // Error messages
  static const String errorGeneral = 'حدث خطأ. حاول مرة أخرى.';
  static const String errorNoInternet = 'لا يوجد اتصال بالإنترنت';
  static const String loading = 'جاري التحميل...';
}