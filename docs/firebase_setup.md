# 🔥 Tawali (طوالي) – Firebase Setup Guide

> **Version:** 1.0.0  
> **Project ID:** `tawali-xxxxx` (wird bei Erstellung vergeben)  
> **Android Package:** `com.mualimx.tawali_app`  
> **Region:** `europe-west1`  
> **Kontakt:** mail2mualimx@gmail.com

---

## 1. Firebase-Projekt erstellen

1. Gehe zu [firebase.google.com](https://console.firebase.google.com) und klicke **"Projekt erstellen"**
2. Projektnamen eingeben: **Tawali (طوالي)**
3. Optional: Google Analytics aktivieren (empfohlen, aber nicht zwingend)
4. Warte auf die Bereitstellung des Projekts

```bash
# Alternativ via Firebase CLI (nach firebase login):
firebase projects:create tawali-prod --display-name "Tawali (طوالي)"
```

---

## 2. Firestore-Datenbank aktivieren

1. Im Firebase Console: **Firestore Database → Datenbank erstellen**
2. **Region auswählen:** `europe-west1` (Belgien / Niederlande)
3. Mit **Testmodus** starten (wir ersetzen die Regeln später)
4. Sicherheitsregeln aus `docs/firestore.rules` übernehmen

```bash
firebase firestore:databases:create --project=PROJECT_ID --location=europe-west1
firebase deploy --only firestore:rules  # nachdem firestore.rules konfiguriert ist
```

---

## 3. Firebase Auth (Phone) aktivieren

1. Im Firebase Console: **Authentication → Sign-in-Methode → Anbieter**
2. **Telefon** aktivieren
3. Testtelefonnummern hinterlegen (optional, für Entwicklung)
4. SHA-256 Fingerprint für die App eintragen (siehe Schritt 6)

```bash
# SHA-256 aus Keytool extrahieren:
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android 2>/dev/null | grep SHA256
```

---

## 4. Firebase Storage aktivieren

1. Im Firebase Console: **Storage → Erste Schritte**
2. Region: **europe-west1**
3. Sicherheitsregeln aus `docs/storage.rules` übernehmen
4. CORS-Konfiguration (optional, bei Web)

```bash
firebase deploy --only storage:rules
```

---

## 5. Android App registrieren

1. Im Firebase Console: **Projektübersicht → Android-Symbol hinzufügen**
2. **Android-Paketname:** `com.mualimx.tawali_app`
3. **App-Nickname (optional):** `Tawali Android`
4. **Debug-Signing-Zertifikat SHA-256:** (aus Schritt 3)
5. **"App registrieren"** klicken
6. **`google-services.json`** herunterladen

---

## 6. google-services.json einbinden

```bash
# Die heruntergeladene Datei nach ~/apps/twally/app/twally_app/ kopieren:
cp ~/Downloads/google-services.json ~/apps/twally/app/twally_app/

# Prüfen, ob die Datei existiert:
ls -la ~/apps/twally/app/twally_app/google-services.json
```

**Wichtig:** `google-services.json` darf NIE in ein öffentliches Git-Repository gelangen.  
Sie ist bereits in `.gitignore` aufgenommen.

---

## 7. FlutterFire konfigurieren

```bash
cd ~/apps/twally/app/twally_app

# FlutterFire CLI installieren (falls nicht vorhanden):
dart pub global activate flutterfire_cli

# Flutter-Projekt mit Firebase verbinden:
flutterfire configure \
  --project=tawali-prod \
  --out=lib/firebase_options.dart \
  --platforms=android,ios,web
```

Dies erzeugt:
- `lib/firebase_options.dart` – plattformspezifische Firebase-Konfiguration
- Aktualisiert `android/build.gradle` und `ios/` Konfigurationen

---

## 8. FCM (Push-Benachrichtigungen) aktivieren

1. Im Firebase Console: **Cloud Messaging**
2. **Android-App** ist bereits registriert (Schritt 5)
3. **Server-Key** notieren (für Backend-Benachrichtigungen):

```bash
# Server-Key aus der Firebase-Konsole kopieren:
# Projekteinstellungen → Cloud Messaging → Server-Key
```

4. In der Flutter-App: `flutter_local_notifications` + `firebase_messaging` verwenden

```dart
// Beispiel: main.dart Initialisierung
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
final messaging = FirebaseMessaging.instance;
await messaging.requestPermission();
final fcmToken = await messaging.getToken();
```

---

## 9. Firebase CLI – Deployment-Befehle

```bash
# Deployment aller Firebase-Regeln:
firebase deploy --only firestore:rules,storage:rules

# Deployment Firestore Indexes:
firebase deploy --only firestore:indexes

# Nur Regeln:
firebase deploy --only firestore:rules
firebase deploy --only storage:rules

# Nur Indexes:
firebase deploy --only firestore:indexes
```

---

## 10. Umgebungsvariablen / Secrets

Für CI/CD (GitHub Actions) müssen folgende Secrets gesetzt werden:

| Variable | Beschreibung |
|----------|-------------|
| `FIREBASE_SERVICE_ACCOUNT` | Firebase Admin SDK JSON (Base64) |
| `GOOGLE_SERVICES_JSON` | `google-services.json` (Base64) |
| `KEYSTORE_JKS` | Release-Keystore (Base64) |
| `KEY_ALIAS` | Keystore-Alias |
| `KEY_PASSWORD` | Keystore-Passwort |
| `STORE_PASSWORD` | Keystore-Store-Passwort |

---

## 11. Nächste Schritte

- [ ] Firebase-Projekt erstellt
- [ ] Firestore (europe-west1) aktiviert
- [ ] Auth (Phone) aktiviert
- [ ] Storage aktiviert
- [ ] Android-App registriert
- [ ] `google-services.json` eingebunden
- [ ] `flutterfire configure` ausgeführt
- [ ] Sicherheitsregeln deployed
- [ ] FCM konfiguriert
- [ ] CI/CD Secrets gesetzt

---

## Troubleshooting

| Problem | Lösung |
|---------|--------|
| `flutterfire configure` schlägt fehl | `firebase login --reauth` ausführen |
| Firestore-Regeln nicht deployed | `firebase init firestore` im Projekt-root ausführen |
| SHA-256 nicht gefunden | Prüfen: `keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore` |
| FCM-Token ist null | Gerät im Hintergrund starten, `onTokenRefresh` listener registrieren |
| Storage-Regel Fehler | Storage-Bucket muss existieren (in Console aktivieren) |