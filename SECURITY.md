# Security Policy \| سياسة الأمان

## Supported Versions

| Version | Supported | Status |
|:--------|:---------:|:-------|
| 1.0.x   | ✅         | Active development |

---

## Firebase Security Rules

### Firestore Rules

Apply these rules in Firebase Console → Firestore Database → Rules.

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper: Check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }

    // Helper: Check if the authenticated user owns the document
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // ===================== USERS =====================
    match /users/{userId} {
      // Users can read/write only their own data
      // Admins can read all users
      allow read: if isOwner(userId) || isAdmin();
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      allow delete: if isAdmin();

      // User subcollections (addresses)
      match /addresses/{addressId} {
        allow read, write: if isOwner(userId);
      }
    }

    // ===================== RESTAURANTS =====================
    match /restaurants/{restaurantId} {
      // Anyone can read restaurant listings
      allow read: if true;
      // Only admins/restaurant owners can write
      allow create, update, delete: if isAdmin() || isRestaurantOwner(restaurantId);

      // Menu items subcollection
      match /menu_items/{itemId} {
        allow read: if true;
        allow write: if isAdmin() || isRestaurantOwner(restaurantId);
      }
    }

    // ===================== ORDERS =====================
    match /orders/{orderId} {
      // Users can read their own orders
      // Restaurants can read orders assigned to them
      // Admins can read all
      allow read: if isOwnerByOrder(orderId) || isAdmin() || isRestaurantByOrder(orderId);
      // Only users can create orders
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      // Only admins/restaurants can update order status
      allow update: if isAdmin() || isRestaurantByOrder(orderId);
      allow delete: if isAdmin();
    }

    // ===================== REVIEWS =====================
    match /reviews/{reviewId} {
      // Anyone can read reviews
      allow read: if true;
      // Users can create their own reviews
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      // Users can update/delete their own reviews
      allow update, delete: if isAuthenticated()
        && resource.data.userId == request.auth.uid;
    }

    // ===================== PROMO CODES =====================
    match /promo_codes/{codeId} {
      // Anyone can read (for validation on checkout)
      allow read: if true;
      // Only admins can write
      allow write: if isAdmin();
    }

    // ===================== ADMIN FUNCTIONS =====================
    function isAdmin() {
      return isAuthenticated()
        && exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }

    function isRestaurantOwner(restaurantId) {
      return isAuthenticated()
        && get(/databases/$(database)/documents/restaurants/$(restaurantId)).data.ownerId == request.auth.uid;
    }

    function isOwnerByOrder(orderId) {
      return isAuthenticated()
        && get(/databases/$(database)/documents/orders/$(orderId)).data.userId == request.auth.uid;
    }

    function isRestaurantByOrder(orderId) {
      return isAuthenticated()
        && get(/databases/$(database)/documents/orders/$(orderId)).data.restaurantId
          in get(/databases/$(database)/documents/restaurants/$(request.auth.uid)).data.assignedRestaurants;
    }
  }
}
```

### Storage Rules

Apply these rules in Firebase Console → Storage → Rules.

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Profile pictures
    match /users/{userId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null
        && request.auth.uid == userId
        && request.resource.size < 5 * 1024 * 1024  // 5MB limit
        && request.resource.contentType.matches('image/.*');
    }

    // Restaurant images
    match /restaurants/{restaurantId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null
        && request.resource.size < 10 * 1024 * 1024  // 10MB limit
        && request.resource.contentType.matches('image/.*');
    }

    // Menu item images
    match /menu_items/{itemId}/{fileName} {
      allow read: if true;
      allow write: if request.auth != null
        && request.resource.size < 5 * 1024 * 1024  // 5MB limit
        && request.resource.contentType.matches('image/.*');
    }

    // Deny everything else
    match /{allPaths=**} {
      allow read, write: if false;
    }
  }
}
```

---

## Data Privacy

### What We Collect
- **Phone number** (for authentication and order contact)
- **Name** (for delivery and order confirmation)
- **Delivery address** (for order fulfillment)
- **Order history** (for user convenience and analytics)
- **FCM token** (for push notifications)

### What We Do NOT Collect
- Passwords (phone OTP only)
- Exact GPS location (we only store user-specified addresses)
- Payment card information
- Biometric data
- Contact list / phonebook
- Social media data

### Data Retention
- User data is retained until account deletion
- Order data is retained for 2 years after last order
- FCM tokens are refreshed on each app launch
- Analytics data is anonymized after 90 days

### Data Deletion
Users can request full account deletion via:
- In-app: Settings → Delete Account
- Email: mail2mualimx@gmail.com (subject: "Account Deletion Request")

Deletion removes: user document, FCM token, personal information.
Order records are anonymized (user ID removed, order data kept for restaurant records).

---

## Authentication Security

### Phone OTP
- OTP codes are **6 digits**, valid for **5 minutes**
- Rate limiting: maximum **5 attempts per phone number per hour**
- Blocked after **10 failed attempts** (24-hour cooldown)
- Firebase handles OTP security — no OTP secrets stored locally
- App uses `RecaptchaVerifier` for Android to prevent SMS fraud

### Session Management
- Auth state persisted via Firebase Auth (automatic token refresh)
- Sessions invalidated on password change / account deletion
- No session tokens stored in SharedPreferences

---

## Network Security

### HTTPS / TLS
- All Firebase communication uses TLS 1.2+
- Firestore data encrypted in transit and at rest (AES-256)
- Firebase Storage uses HTTPS for all uploads/downloads

### API Endpoints
- No custom backend endpoints — all communication goes through Firebase
- Firebase Authentication handles token generation and verification
- Firebase Security Rules enforce access control at the database level

---

## OTP Rate Limiting

```dart
// In auth_provider.dart — pseudocode
class AuthProvider extends StateNotifier<AuthState> {
  final Map<String, int> _attemptCounts = {};
  final Map<String, DateTime> _blockedUntil = {};
  static const int MAX_ATTEMPTS = 5;
  static const Duration BLOCK_DURATION = Duration(hours: 1);
  static const Duration OTP_TIMEOUT = Duration(minutes: 5);

  Future<void> sendOtp(String phone) async {
    // Check if phone is blocked
    if (_blockedUntil.containsKey(phone)) {
      if (DateTime.now().isBefore(_blockedUntil[phone]!)) {
        throw Exception('Too many attempts. Try again later.');
      }
      _blockedUntil.remove(phone);
      _attemptCounts.remove(phone);
    }

    // Track attempts
    _attemptCounts[phone] = (_attemptCounts[phone] ?? 0) + 1;

    if (_attemptCounts[phone]! >= MAX_ATTEMPTS) {
      _blockedUntil[phone] = DateTime.now().add(BLOCK_DURATION);
      throw Exception('Too many OTP requests. Blocked for 1 hour.');
    }

    // Send OTP via Firebase Auth
    await _firebaseAuth.sendOtp(phone);
  }
}
```

---

## Environment Variables & Secrets

| Secret | Storage Location | Purpose |
|:-------|:-----------------|:--------|
| Firebase API Key | `google-services.json` | Firebase SDK init |
| Firebase App ID | `google-services.json` | Firebase SDK init |
| Firebase Project ID | `firebase_options.dart` | Firebase SDK init |
| Storage Bucket | `firebase_options.dart` | Firebase Storage init |
| Map API Key | `.env` (optional) | Custom map tiles |

**Never commit secrets to version control.** `google-services.json` is in `.gitignore`.

---

## Reporting a Vulnerability

If you discover a security vulnerability in Tawali, please report it privately.

**Contact:** mail2mualimx@gmail.com
**Subject:** "Tawali Security Vulnerability"

We will:
1. Acknowledge receipt within **48 hours**
2. Investigate and fix within **14 days** (critical: 72 hours)
3. Notify affected users if data was compromised
4. Release a security patch with disclosure

**Do not** report security issues on public GitHub issues or social media.

---

## Security Checklist

- [x] Firebase Auth with phone OTP (no password storage)
- [x] Firestore security rules with role-based access
- [x] Storage security rules with file type and size validation
- [x] OTP rate limiting (5 attempts/hour, 24h block)
- [x] HTTPS/TLS for all network communication
- [x] No hardcoded API keys in source code
- [x] .gitignore includes secrets and config files
- [x] Input validation on all user inputs
- [x] Data encryption at rest (Firebase managed)
- [x] Privacy policy accessible in-app
- [x] Account deletion available in-app
- [x] No third-party tracking SDKs
- [x] FCM notifications minimal and relevant