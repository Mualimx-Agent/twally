# Deployment Guide \| دليل النشر

## Overview

This guide covers deploying **Tawali (طوالي)** to production environments: Firebase backend, Google Play Store, and CI/CD pipeline.

---

## 1. Firebase Deployment

### Prerequisites
```bash
npm install -g firebase-tools
firebase login
```

### 1.1 Initialize Firebase Project
```bash
cd app/twally_app

# Initialize Firebase (if not done already)
firebase init

# Select:
#   [x] Firestore
#   [x] Storage
#   [x] Hosting (for web)
#   [x] Emulators (for local dev)
```

### 1.2 Deploy Firestore Rules
```bash
# Edit firestore.rules with the rules from SECURITY.md
firebase deploy --only firestore:rules
```

### 1.3 Deploy Storage Rules
```bash
# Edit storage.rules with the rules from SECURITY.md
firebase deploy --only storage:rules
```

### 1.4 Deploy Firestore Indexes
Create `firestore.indexes.json`:
```json
{
  "indexes": [
    {
      "collectionGroup": "orders",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "menu_items",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "restaurantId", "order": "ASCENDING" },
        { "fieldPath": "category", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "reviews",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "restaurantId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```
```bash
firebase deploy --only firestore:indexes
```

### 1.5 Deploy Everything
```bash
firebase deploy
```

---

## 2. Google Play Store Release

### 2.1 Prerequisites
- Google Play Developer account ($25 one-time fee)
- App signed with upload keystore
- App screenshots (phone + tablet)
- App description (Arabic + English)
- Privacy policy URL
- Content rating questionnaire completed

### 2.2 Generate Signed Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# Create key.properties in android/
cat > android/key.properties << EOF
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=../upload-keystore.jks
EOF
```

### 2.3 Configure Signing in `android/app/build.gradle`
```gradle
android {
    // ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // ...
        }
    }
}
```

### 2.4 Build Release Bundle
```bash
# Clean
flutter clean

# Get dependencies
flutter pub get

# Build App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### 2.5 Upload to Play Console
1. Go to [Google Play Console](https://play.google.com/console)
2. Create new app → **Tawali (طوالي)**
3. Complete store listing:
   - **App name:** طوالي - Tawali
   - **Short description (80 chars):** طوالي – تطبيق توصيل طعام سوداني. اطلب من أفضل مطاعم الخرطوم
   - **Full description:** (Arabic + English, 4000 chars max)
   - **Screenshots:** 8+ screenshots (phone + 7-inch tablet)
   - **Feature graphic:** 1024×500px
   - **Icon:** 512×512px
   - **Category:** Food & Drink
   - **Content rating:** Complete questionnaire
   - **Privacy policy:** Host at `https://your-domain.com/privacy`
4. Upload `app-release.aab` to Production track
5. Complete "App content" section (ads ID, etc.)
6. Submit for review

### 2.6 Play Store Metadata

**Short description (Arabic):**
```
طوالي – تطبيق توصيل طعام سوداني. اطلب من أفضل مطاعم الخرطوم
```

**Short description (English):**
```
Tawali – Sudanese food delivery app. Order from Khartoum's best restaurants.
```

**Full description (Arabic):**
```
طوالي هو أول تطبيق توصيل طعام سوداني يربطك بأفضل المطاعم في الخرطوم.

مميزات التطبيق:
• تصفح المطاعم وقوائم الطعام بالعربية
• تسجيل الدخول برقم الهاتف عبر OTP
• إضافة الأطباق إلى السلة بسهولة
• تتبع الطلب في الوقت الفعلي
• تقييم المطاعم وكتابة المراجعات
• حفظ المطاعم المفضلة
• سجل الطلبات السابقة
• دفع عند الاستلام (COD)
• إشعارات فورية لحالة الطلب
• واجهة عربية كاملة (RTL)

طوالي – طعم السودان، توصيل إلى باب بيتك.
```

**Full description (English):**
```
Tawali is Sudan's first food delivery app connecting you to the best restaurants in Khartoum.

Features:
• Browse restaurants and menus in Arabic
• Phone number OTP login
• Easy add-to-cart functionality
• Real-time order tracking
• Restaurant ratings and reviews
• Save favorite restaurants
• Order history
• Cash on delivery (COD)
• Push notifications for order status
• Full Arabic RTL interface

Tawali – Sudan's taste, delivered to your door.
```

---

## 3. CI/CD with GitHub Actions

### 3.1 Create Workflow File

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Tawali

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  analyze:
    name: Analyze & Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.44.x'
          channel: 'stable'
      - name: Install dependencies
        run: flutter pub get
        working-directory: app/twally_app
      - name: Analyze
        run: flutter analyze
        working-directory: app/twally_app
      - name: Run tests
        run: flutter test
        working-directory: app/twally_app

  build-android:
    name: Build Android
    needs: analyze
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.44.x'
          channel: 'stable'
      - name: Install dependencies
        run: flutter pub get
        working-directory: app/twally_app
      - name: Build APK
        run: flutter build apk --release
        working-directory: app/twally_app
      - name: Build App Bundle
        run: flutter build appbundle --release
        working-directory: app/twally_app
      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: release-apk
          path: app/twally_app/build/app/outputs/flutter-apk/*.apk
      - name: Upload AAB artifact
        uses: actions/upload-artifact@v4
        with:
          name: release-aab
          path: app/twally_app/build/app/outputs/bundle/release/*.aab

  deploy-firebase:
    name: Deploy Firebase Rules & Indexes
    needs: analyze
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - name: Install Firebase Tools
        run: npm install -g firebase-tools
      - name: Deploy Firestore Rules
        run: firebase deploy --only firestore:rules --token "${{ secrets.FIREBASE_TOKEN }}"
        working-directory: app/twally_app
      - name: Deploy Storage Rules
        run: firebase deploy --only storage:rules --token "${{ secrets.FIREBASE_TOKEN }}"
        working-directory: app/twally_app
      - name: Deploy Firestore Indexes
        run: firebase deploy --only firestore:indexes --token "${{ secrets.FIREBASE_TOKEN }}"
        working-directory: app/twally_app
```

### 3.2 GitHub Secrets Setup

In GitHub repository → Settings → Secrets and variables → Actions, add:

| Secret | Value |
|:-------|:------|
| `FIREBASE_TOKEN` | `firebase login:ci` output |
| `KEY_STORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |
| `SIGNING_KEY` | Base64-encoded keystore file |

### 3.3 Optional: Play Store Auto-Deploy

Use [github.com/r0adkll/upload-google-play](https://github.com/r0adkll/upload-google-play) action to auto-upload to Google Play Console on release tags.

---

## 4. Environment Variables

### Development
```env
# firebase_options.dart handles most config
# For development, default Firebase project is used
FLUTTER_ENV=development
```

### Staging
```env
FLUTTER_ENV=staging
# Use a separate Firebase project for staging
```

### Production
```env
FLUTTER_ENV=production
# Production Firebase project
```

### Configuration in Code
```dart
// lib/core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'طوالي';
  static const String appNameEn = 'Tawali';
  static const String developerEmail = 'mail2mualimx@gmail.com';
  static const String appVersion = '1.0.0';

  // Firebase
  static const String defaultCountryCode = '+249';  // Sudan
  static const int otpTimeoutSeconds = 300;  // 5 minutes
  static const int maxOtpAttempts = 5;

  // Order
  static const List<String> orderStatuses = [
    'pending',
    'confirmed',
    'preparing',
    'out_for_delivery',
    'delivered',
    'cancelled',
  ];
}
```

---

## 5. Monitoring

### Firebase Crashlytics
```bash
# Add to pubspec.yaml
flutter pub add firebase_crashlytics

# Initialize in main.dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```

### Firebase Performance
```bash
flutter pub add firebase_performance
```

### Firebase Analytics
```bash
flutter pub add firebase_analytics
```

---

## 6. Rollback Plan

### If a release has critical bugs:
1. **Revert the commit** that introduced the bug
2. **Push a hotfix** with a new version (e.g., 1.0.1)
3. **Deploy the fix** to Play Store as an emergency release
4. **Update Firebase Rules** if needed

### Emergency Rollback Checklist:
```bash
git revert HEAD --no-edit
git push origin main
flutter build appbundle --release
# Upload to Play Store immediately
```

---

## Deployment Checklist

- [ ] Firebase project created and configured
- [ ] Firestore rules deployed
- [ ] Storage rules deployed
- [ ] Firestore indexes created
- [ ] Phone Auth enabled in Firebase Console
- [ ] FCM enabled and server key noted
- [ ] Keystore generated and configured
- [ ] App signed for release
- [ ] Privacy policy hosted
- [ ] Play Store listing complete
- [ ] CI/CD pipeline configured
- [ ] Crashlytics enabled
- [ ] Test data populated (10+ restaurants, 50+ menu items)
- [ ] OTP tested with real Sudanese (+249) numbers
- [ ] Push notifications tested for all order statuses