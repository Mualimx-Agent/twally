# Tawali (طوالي) — Architecture Document

## Overview

Tawali follows a **feature-first architecture** with clear separation of concerns. Each feature is self-contained in its own directory under `lib/features/`, while shared code lives in `lib/core/` and `lib/services/`.

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── app_strings.dart
│   └── ... (theme, utils, extensions)
├── features/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── otp_screen.dart
│   │   └── profile_setup_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── restaurant/
│   │   └── restaurant_detail_screen.dart
│   ├── cart/
│   │   ├── cart_screen.dart
│   │   └── add_address_screen.dart
│   ├── checkout/
│   │   ├── checkout_screen.dart
│   │   └── order_confirmation_screen.dart
│   ├── orders/
│   │   ├── order_history_screen.dart
│   │   ├── order_tracking_screen.dart
│   │   └── orders_list_screen.dart
│   ├── search/
│   │   └── search_screen.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── edit_profile_screen.dart
│   │   └── addresses_screen.dart
│   ├── favorites/
│   │   └── favorites_screen.dart
│   ├── reviews/
│   │   └── reviews_screen.dart
│   ├── settings/
│   │   ├── settings_screen.dart
│   │   └── language_screen.dart
│   ├── splash/
│   │   └── splash_screen.dart
│   └── onboarding/
│       └── onboarding_screen.dart
├── models/
│   ├── user_model.dart
│   ├── restaurant_model.dart
│   ├── menu_item_model.dart
│   ├── order_model.dart
│   ├── review_model.dart
│   └── promo_code_model.dart
├── providers/
│   ├── auth_provider.dart
│   ├── restaurant_provider.dart
│   ├── cart_provider.dart
│   ├── order_provider.dart
│   └── locale_provider.dart
├── services/
│   └── firebase_service.dart
├── theme/
│   ├── app_theme.dart
│   └── app_colors.dart
├── router/
│   └── app_router.dart
└── main.dart
```

---

## Models (6 Models)

| Model | File | Key Fields |
|:------|:-----|:-----------|
| **UserModel** | `user_model.dart` | `id`, `name`, `phone`, `email`, `addresses`, `createdAt` |
| **RestaurantModel** | `restaurant_model.dart` | `id`, `nameAr`/`nameEn`, `description`, `cuisine`, `rating`, `deliveryFee`, `minOrder`, `isOpen`, `menuItems` |
| **MenuItemModel** | `menu_item_model.dart` | `id`, `nameAr`/`nameEn`, `description`, `price`, `imageUrl`, `category`, `isAvailable` |
| **OrderModel** | `order_model.dart` | `id`, `userId`, `restaurantId`, `items`, `total`, `status`, `address`, `createdAt` |
| **ReviewModel** | `review_model.dart` | `id`, `userId`, `restaurantId`, `rating`, `comment`, `createdAt` |
| **PromoCodeModel** | `promo_code_model.dart` | `id`, `code`, `discount`, `minOrder`, `expiresAt`, `usageLimit` |

---

## Providers (5 Providers)

| Provider | File | Responsibility |
|:---------|:-----|:---------------|
| **AuthProvider** | `auth_provider.dart` | Phone OTP authentication, user session, profile management |
| **RestaurantProvider** | `restaurant_provider.dart` | Restaurant listing, search, filtering, menu items |
| **CartProvider** | `cart_provider.dart` | Cart state, add/remove items, quantity control, total calculation |
| **OrderProvider** | `order_provider.dart` | Order creation, order history, real-time tracking |
| **LocaleProvider** | `locale_provider.dart` | Language selection (Arabic/English), RTL direction |

All providers use **Riverpod** (`flutter_riverpod`) for state management. Key patterns:

- **StateNotifierProvider** for mutable state (Cart, Auth, Locale)
- **FutureProvider** / **StreamProvider** for Firebase data
- **Provider** for derived/read-only state

---

## Routing (go_router — 17+ Routes)

Defined in `lib/router/app_router.dart`.

| Route | Path | Screen |
|:------|:-----|:-------|
| Splash | `/` | `SplashScreen` |
| Onboarding | `/onboarding` | `OnboardingScreen` |
| Login | `/login` | `LoginScreen` |
| OTP | `/otp/:phone` | `OtpScreen` |
| Profile Setup | `/profile-setup` | `ProfileSetupScreen` |
| Home | `/home` | `HomeScreen` |
| Restaurant Detail | `/restaurant/:id` | `RestaurantDetailScreen` |
| Search | `/search` | `SearchScreen` |
| Cart | `/cart` | `CartScreen` |
| Add Address | `/add-address` | `AddAddressScreen` |
| Checkout | `/checkout` | `CheckoutScreen` |
| Order Confirmation | `/order-confirmation` | `OrderConfirmationScreen` |
| Orders List | `/orders` | `OrdersListScreen` |
| Order History | `/orders/history` | `OrderHistoryScreen` |
| Order Tracking | `/order/:id/track` | `OrderTrackingScreen` |
| Favorites | `/favorites` | `FavoritesScreen` |
| Reviews | `/restaurant/:id/reviews` | `ReviewsScreen` |
| Profile | `/profile` | `ProfileScreen` |
| Edit Profile | `/profile/edit` | `EditProfileScreen` |
| Addresses | `/profile/addresses` | `AddressesScreen` |
| Settings | `/settings` | `SettingsScreen` |
| Language | `/settings/language` | `LanguageScreen` |

Route guards (redirects):
- Unauthenticated users → `/login`
- First-time users → `/onboarding`
- After OTP but no profile → `/profile-setup`

---

## Firebase Data Model

### Collections (6)

#### `users`
```json
{
  "id": "string",
  "name": "string",
  "phone": "string",
  "email": "string?",
  "addresses": [
    {
      "id": "string",
      "label": "string",
      "street": "string",
      "city": "string",
      "lat": "number",
      "lng": "number"
    }
  ],
  "createdAt": "timestamp",
  "fcmToken": "string?"
}
```

#### `restaurants`
```json
{
  "id": "string",
  "nameAr": "string",
  "nameEn": "string",
  "descriptionAr": "string",
  "descriptionEn": "string",
  "cuisine": "string",
  "rating": "number",
  "imageUrl": "string",
  "deliveryFee": "number",
  "minOrder": "number",
  "isOpen": "boolean",
  "workingHours": {
    "open": "string",
    "close": "string"
  },
  "location": {
    "lat": "number",
    "lng": "number"
  },
  "createdAt": "timestamp"
}
```

#### `menu_items`
```json
{
  "id": "string",
  "restaurantId": "string",
  "nameAr": "string",
  "nameEn": "string",
  "descriptionAr": "string",
  "descriptionEn": "string",
  "price": "number",
  "imageUrl": "string",
  "category": "string",
  "isAvailable": "boolean",
  "createdAt": "timestamp"
}
```

#### `orders`
```json
{
  "id": "string",
  "userId": "string",
  "restaurantId": "string",
  "restaurantName": "string",
  "items": [
    {
      "menuItemId": "string",
      "name": "string",
      "quantity": "number",
      "price": "number"
    }
  ],
  "subtotal": "number",
  "deliveryFee": "number",
  "total": "number",
  "status": "pending | confirmed | preparing | out_for_delivery | delivered | cancelled",
  "deliveryAddress": {
    "street": "string",
    "city": "string",
    "lat": "number",
    "lng": "number"
  },
  "paymentMethod": "cod",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### `reviews`
```json
{
  "id": "string",
  "userId": "string",
  "userName": "string",
  "restaurantId": "string",
  "rating": "number",
  "comment": "string",
  "createdAt": "timestamp"
}
```

#### `promo_codes`
```json
{
  "id": "string",
  "code": "string",
  "discountType": "percentage | fixed",
  "discountValue": "number",
  "minOrder": "number",
  "maxUses": "number",
  "currentUses": "number",
  "expiresAt": "timestamp",
  "isActive": "boolean"
}
```

---

## RTL (Right-to-Left) Strategy

Tawali fully supports Arabic with RTL layout.

### Implementation

1. **MaterialApp wraps Directionality:**
   ```dart
   MaterialApp(
     locale: localeProvider.locale,    // 'ar' or 'en'
     localizationsDelegates: AppLocalizations.localizationsDelegates,
     supportedLocales: const [Locale('ar'), Locale('en')],
     localeResolutionCallback: (locale, supportedLocales) {
       // Default to Arabic
       return const Locale('ar');
     },
   )
   ```

2. **Text direction changes automatically** by locale — no manual `TextDirection.rtl` needed.

3. **Arabic-first content:**
   - All restaurant names, menu items, and descriptions stored in both Arabic and English
   - UI defaults to Arabic text when locale is `ar`
   - `flutter_localizations` handles date/number formatting

4. **Layout testing:**
   - Test with `flutter run` on devices set to Arabic locale
   - Use Flutter's `Directionality` widget for isolated RTL testing
   - Check all ListTile, SliverAppBar, and BottomNavigationBar widgets for correct RTL behavior

5. **String management:** All user-facing strings in `lib/core/constants/app_strings.dart` with `.ar` and `.en` methods.

---

## State Flow

```
User Action → Screen Widget → Provider (Riverpod) → Firebase Service → Firestore
                                                         ↓
                                                    State Update
                                                         ↓
                                                    UI Rebuild
```

### Auth Flow
```
LoginScreen → enter phone → AuthProvider.signInWithPhone()
  → Firebase Auth sends OTP → OtpScreen → enter code
  → AuthProvider.verifyOtp() → AuthProvider.setUser()
  → Redirect to ProfileSetupScreen (new user) or HomeScreen (returning)
```

### Order Flow
```
RestaurantDetailScreen → select items → CartProvider.addItem()
CartScreen → review items → CheckoutScreen → confirm order
  → OrderProvider.createOrder() → Firestore write
  → FCM notification sent → OrderConfirmationScreen
  → OrderTrackingScreen (real-time via StreamProvider)
```

---

## Dependencies & Versions

| Package | Version | Purpose |
|:--------|:--------|:--------|
| `firebase_core` | ^4.13.0 | Firebase initialization |
| `firebase_auth` | ^6.5.7 | Phone OTP authentication |
| `cloud_firestore` | ^6.8.0 | Database |
| `firebase_storage` | ^13.4.6 | Image uploads |
| `firebase_messaging` | ^16.5.0 | Push notifications |
| `flutter_riverpod` | ^2.6.1 | State management |
| `provider` | ^6.1.2 | Legacy state management |
| `go_router` | ^17.5.0 | Declarative routing |
| `cached_network_image` | ^3.4.1 | Image caching |
| `flutter_map` | ^8.3.1 | Map display |
| `latlong2` | ^0.10.1 | Coordinate handling |
| `intl` | ^0.20.2 | Internationalization |
| `shared_preferences` | ^2.5.5 | Local storage |
| `path_provider` | ^2.1.6 | File paths |
| `google_fonts` | ^8.2.1 | Custom fonts |
| `shimmer` | ^3.0.0 | Loading skeletons |
| `connectivity_plus` | ^7.3.1 | Network monitoring |
| `url_launcher` | ^6.3.2 | Open external links |