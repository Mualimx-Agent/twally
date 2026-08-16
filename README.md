# طوالي (Tawali) — Sudanese Food Delivery App

**Tawali (طوالي)** is a modern food delivery platform built for Sudan. Order from Khartoum's best restaurants with a fully Arabic (RTL) interface.

![Tawali App](app/twally_app/assets/feature_graphic.png)

> **Developer:** Mualimx Apps — mail2mualimx@gmail.com
> **Platform:** Android · iOS · Web
> **Version:** 1.0.0

---

## المميزات (Features)

### العربية
- 🇸🇩 تطبيق توصيل طعام سوداني بالكامل
- 🔐 تسجيل الدخول عبر OTP (رقم الهاتف)
- 🏪 تصفح المطاعم في الخرطوم
- 📋 قائمة طعام مفصلة مع الصور
- 🛒 إضافة إلى السلة بسهولة
- 📍 تتبع الطلب في الوقت الفعلي
- ⭐ تقييمات ومراجعات المطاعم
- ❤️ حفظ المطاعم المفضلة
- 🔍 بحث متقدم عن المطاعم والأطباق
- 📜 سجل الطلبات السابقة
- 👤 إدارة الملف الشخصي والعناوين
- 🌙 واجهة عربية كاملة (RTL)
- 🔔 إشعارات Firebase (حالات الطلب)
- 💳 دفع عند الاستلام (COD)

### English
- 🇸🇩 Fully Sudanese food delivery application
- 🔐 OTP phone number authentication
- 🏪 Browse restaurants across Khartoum
- 📋 Detailed menu with images
- 🛒 Easy cart management
- 📍 Real-time order tracking
- ⭐ Restaurant ratings and reviews
- ❤️ Favorite restaurants
- 🔍 Advanced search for restaurants and dishes
- 📜 Order history
- 👤 Profile and address management
- 🌙 Full Arabic RTL interface
- 🔔 Firebase push notifications (order status)
- 💳 Cash on delivery (COD)

---

## Screens (22 Screens)

| Screen | Description |
|:-------|:------------|
| Splash | Animated app launch |
| Onboarding | 3-step feature intro |
| Login | Phone number input |
| OTP | Verification code |
| Profile Setup | Name, phone, address |
| Home | Restaurant listings |
| Search | Search & filter |
| Restaurant Detail | Menu, info, reviews |
| Cart | Order summary |
| Add Address | New delivery address |
| Checkout | Confirm & place order |
| Order Confirmation | Success screen |
| Orders List | Active orders |
| Order History | Past orders |
| Order Tracking | Live order status |
| Favorites | Saved restaurants |
| Reviews | Write & view reviews |
| Profile | User profile |
| Edit Profile | Edit user info |
| Addresses | Saved addresses |
| Settings | App settings |
| Language | Language selection |

---

## Technical Stack

| Layer | Technology |
|:------|:-----------|
| **Framework** | Flutter 3.44+ · Dart 3.12+ |
| **State Management** | Riverpod + Provider |
| **Routing** | go_router (17 routes) |
| **Backend** | Firebase |
| **Auth** | Firebase Auth (Phone OTP) |
| **Database** | Cloud Firestore |
| **Storage** | Firebase Storage |
| **Notifications** | Firebase Cloud Messaging (FCM) |
| **Maps** | Flutter Map + OpenStreetMap |
| **Caching** | CachedNetworkImage · SharedPreferences |
| **Fonts** | Google Fonts |
| **Connectivity** | connectivity_plus |

---

## Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/mualimx/twally.git
cd twally

# 2. Navigate to the Flutter app
cd app/twally_app

# 3. Get dependencies
flutter pub get

# 4. Run the app
flutter run
```

---

## Firebase Setup

Follow these steps to connect Firebase:

1. **Create a Firebase project** at [firebase.google.com](https://firebase.google.com)
2. **Register your app** (Android/iOS) in the Firebase Console
3. **Download config files:**
   - Android: `google-services.json` → `app/twally_app/android/app/`
   - iOS: `GoogleService-Info.plist` → `app/twally_app/ios/`
4. **Run FlutterFire CLI:**
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=your-project-id
   ```
5. **Enable Auth:** Firebase Console → Authentication → Sign-in method → Phone
6. **Enable Firestore:** Firebase Console → Firestore Database → Create database
7. **Enable Storage:** Firebase Console → Storage → Get started

---

## Build

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## Architecture

This app follows a **feature-first architecture** with provider-based state management. See [ARCHITECTURE.md](ARCHITECTURE.md) for details.

---

## License

```
Copyright 2025 Mualimx Apps

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```