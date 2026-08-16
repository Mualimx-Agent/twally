/// Simulierter Firebase-Service.
///
/// Diese Klasse stellt statische Methoden und Placeholder für Firebase
/// bereit. Um echtes Firebase zu verwenden:
/// 1. firebase_options.dart generieren (`flutterfire configure`)
/// 2. In main.dart Firebase.initializeApp() auskommentieren
/// 3. Die echten Firebase-Instanzen in den Providern verwenden
///
/// Aktuell werfen alle Datenbank-Methoden UnimplementedError,
/// um daran zu erinnern, dass Firebase eingerichtet werden muss.
class FirebaseService {
  FirebaseService._();

  /// Platzhalter für den aktuellen User (wird vom Auth-Provider verwaltet)
  static String? currentUserId;

  /// Collection-Referenzen (als Strings für einfache Umstellung)
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String menuItemsCollection = 'menu_items';
  static const String ordersCollection = 'orders';
  static const String reviewsCollection = 'reviews';
  static const String promoCodesCollection = 'promo_codes';

  // ------------------------------------------------------------------
  //  AUTH
  // ------------------------------------------------------------------

  /// FirebaseAuth sendOtp – simuliert
  static Future<void> sendOtp(String phone) {
    throw UnimplementedError(
      'Firebase Auth ist nicht konfiguriert. '
      'Füge firebase_options.dart hinzu und initialisiere Firebase in main.dart.\n'
      'Aktuell läuft die OTP-Logik über AuthProvider (simuliert).',
    );
  }

  /// FirebaseAuth verifyOtp – simuliert
  static Future<bool> verifyOtp(String code, String verificationId) {
    throw UnimplementedError(
      'Firebase Auth ist nicht konfiguriert. '
      'Aktuell läuft die OTP-Logik über AuthProvider (simuliert).',
    );
  }

  // ------------------------------------------------------------------
  //  FIRESTORE – User
  // ------------------------------------------------------------------

  static Future<Map<String, dynamic>?> getUser(String userId) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $usersCollection, Document: $userId',
    );
  }

  static Future<void> setUser(String userId, Map<String, dynamic> data) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $usersCollection, Document: $userId',
    );
  }

  static Future<void> updateUser(String userId, Map<String, dynamic> data) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $usersCollection, Document: $userId',
    );
  }

  // ------------------------------------------------------------------
  //  FIRESTORE – Restaurants & Menu Items
  // ------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> getRestaurants() {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $restaurantsCollection',
    );
  }

  static Future<Map<String, dynamic>?> getRestaurant(String restaurantId) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $restaurantsCollection, Document: $restaurantId',
    );
  }

  static Future<List<Map<String, dynamic>>> getMenuItems(String restaurantId) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $menuItemsCollection, Filter: restaurant_id == $restaurantId',
    );
  }

  // ------------------------------------------------------------------
  //  FIRESTORE – Orders
  // ------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> getUserOrders(String userId) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $ordersCollection, Filter: user_id == $userId',
    );
  }

  static Future<Map<String, dynamic>?> getOrder(String orderId) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $ordersCollection, Document: $orderId',
    );
  }

  static Future<void> createOrder(Map<String, dynamic> orderData) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $ordersCollection',
    );
  }

  static Future<void> updateOrder(String orderId, Map<String, dynamic> data) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $ordersCollection, Document: $orderId',
    );
  }

  // ------------------------------------------------------------------
  //  FIRESTORE – Reviews
  // ------------------------------------------------------------------

  static Future<List<Map<String, dynamic>>> getRestaurantReviews(
      String restaurantId) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $reviewsCollection, Filter: restaurant_id == $restaurantId',
    );
  }

  static Future<void> createReview(Map<String, dynamic> reviewData) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $reviewsCollection',
    );
  }

  // ------------------------------------------------------------------
  //  FIRESTORE – Promo Codes
  // ------------------------------------------------------------------

  static Future<Map<String, dynamic>?> getPromoCode(String code) {
    throw UnimplementedError(
      'Firebase Firestore ist nicht konfiguriert. '
      'Collection: $promoCodesCollection, Filter: code == $code',
    );
  }

  // ------------------------------------------------------------------
  //  FIREBASE STORAGE
  // ------------------------------------------------------------------

  static Future<String> uploadImage({
    required String path,
    required List<int> bytes,
  }) {
    throw UnimplementedError(
      'Firebase Storage ist nicht konfiguriert. '
      'Pfad: $path',
    );
  }
}