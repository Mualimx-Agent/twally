# Changelog

All notable changes to **Tawali (طوالي)** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2025-08-16

### Added
- **Authentication**
  - Phone number OTP login with Firebase Auth
  - Automatic SMS verification for Sudanese (+249) numbers
  - Profile setup (name, phone, default address)
  - Session persistence across restarts

- **Home Screen**
  - Restaurant listing with horizontal category chips
  - Featured/promoted restaurant carousel
  - Search bar with instant navigation to search screen
  - Pull-to-refresh for latest data

- **Restaurant Detail**
  - Full menu with categorized items
  - Menu item cards with image, name, price, and add-to-cart
  - Restaurant info: rating, cuisine, delivery fee, minimum order, hours
  - Reviews section with average rating and user reviews
  - Favorite toggle button

- **Cart**
  - Add/remove items with quantity controls
  - Real-time subtotal, delivery fee, and total calculation
  - Minimum order validation
  - Add delivery address screen with map picker
  - Clear cart option

- **Checkout**
  - Order summary with all items and pricing
  - Delivery address display
  - Payment method selection (Cash on Delivery)
  - Place order with confirmation dialog

- **Order Management**
  - Active orders list with status badges
  - Order history with completed orders
  - Real-time order tracking with live status updates
  - Status flow: Pending → Confirmed → Preparing → Out for Delivery → Delivered

- **Search**
  - Search restaurants by name (Arabic and English)
  - Filter by cuisine type
  - Sort by rating, delivery fee, or distance

- **Favorites**
  - Save/unsave favorite restaurants
  - Dedicated favorites screen with saved restaurants list

- **Reviews**
  - Write reviews with star rating (1-5)
  - View all reviews for a restaurant
  - User name and timestamp displayed

- **Profile**
  - View and edit personal information
  - Manage saved addresses
  - Settings screen with language toggle
  - Language selection (Arabic / English)

- **Onboarding**
  - 3-step onboarding flow for first-time users
  - App feature introduction with illustrations

- **Splash Screen**
  - Animated app launch with branding

- **Infrastructure**
  - Firebase Auth with phone OTP
  - Cloud Firestore for all data persistence
  - Firebase Storage for restaurant/menu images
  - Firebase Cloud Messaging for push notifications
  - Flutter Map + OpenStreetMap for location picker
  - Riverpod state management across all providers
  - go_router with 22 screen routes
  - Full Arabic (RTL) support via flutter_localizations
  - Offline connectivity monitoring
  - Image caching with CachedNetworkImage
  - Shimmer loading skeletons
  - SharedPreferences for local settings