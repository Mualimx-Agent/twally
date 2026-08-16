# Hermes Agent Guide \| دليل وكيل هيرميز

This document describes how **Hermes Agent** is configured to assist in the development of **Tawali (طوالي)**.

---

## Overview

[Hermes Agent](https://hermes-agent.nousresearch.com) is an AI-powered development assistant built by Nous Research. It is configured with a custom profile and skills to accelerate Tawali's Flutter development workflow.

---

## Agent Configuration

### Profile: `tawali-dev`

Location: `~/.hermes/profiles/tawali-dev/`

### Key Skills

| Skill | Purpose |
|:------|:--------|
| **flutter-dev** | Flutter project creation, `pub get`, `flutter build`, `flutter analyze`, `flutter test` |
| **firebase-setup** | Firebase project configuration, `flutterfire configure`, rules deployment |
| **documentation** | Markdown docs, README, changelog generation |
| **arabic-localization** | Arabic (RTL) string management, translation quality checks |

### Environment

The workspace is at `/home/ubuntu/apps/twally/` with the Flutter app at `app/twally_app/`.

```bash
# Current project state
~/apps/twally/
├── README.md
├── INSTALL.md
├── ARCHITECTURE.md
├── CHANGELOG.md
├── LICENSE
├── SECURITY.md
├── DEPLOYMENT.md
├── CONTRIBUTING.md
├── HALAL-CHECKLIST.md
├── AGENTS.md
└── app/
    └── twally_app/  (Flutter project)
```

---

## Developer Workflow

### 1. Daily Development

```bash
# Hermes initiates the session
hermes start --profile tawali-dev

# Agent loads project context
cd ~/apps/twally/app/twally_app

# Agent checks git status
git status

# Agent reviews recent changes
git log --oneline -10
```

### 2. Feature Development

```text
Developer: "Add a new 'Promotions' screen"

Hermes Agent will:
1. Create lib/features/promotions/promotions_screen.dart
2. Add route in lib/router/app_router.dart
3. Add Arabic/English strings in app_strings.dart
4. Register any new providers
5. Run flutter analyze
6. Run flutter test
7. Update CHANGELOG.md
```

### 3. Bug Fixes

```text
Developer: "Fix the cart total calculation bug"

Hermes Agent will:
1. Find the relevant provider code
2. Identify the calculation bug
3. Fix and verify with tests
4. Run flutter analyze
5. Update CHANGELOG.md with fix details
```

### 4. Firebase Updates

```text
Developer: "Add a new 'categories' collection to Firestore"

Hermes Agent will:
1. Create the model (lib/models/category_model.dart)
2. Add Firestore rules in SECURITY.md
3. Add collection references in firebase_service.dart
4. Create provider for categories
5. Create a new screen or widget
6. Update ARCHITECTURE.md
7. Deploy rules via firebase deploy
```

---

## Build Process

### Standard Build Commands

```bash
# Hermes Agent runs these automatically:
cd ~/apps/twally/app/twally_app

# Analyze
flutter analyze

# Run tests
flutter test

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### CI/CD Automation

The agent can trigger GitHub Actions workflows:

```bash
# Trigger deployment
git push origin main
# GitHub Actions handles: analyze → test → build → deploy
```

---

## Agent Capabilities

### What Hermes Can Do

| Capability | How to Trigger |
|:-----------|:---------------|
| Create Flutter widgets | "Create a restaurant card widget" |
| Write Firebase rules | "Add security rules for orders collection" |
| Generate documentation | "Update the README with new features" |
| Run Flutter commands | "Run flutter analyze and fix issues" |
| Manage git operations | "Commit the changes with a descriptive message" |
| Create GitHub Actions | "Set up CI/CD pipeline" |
| Test Arabic RTL layout | "Check if the new screen handles RTL correctly" |
| Debug build errors | "Fix the APK build failure" |
| Update translations | "Add Arabic translations for the new strings" |

### What Hermes Cannot Do (Yet)

- Test on physical devices (emulator only)
- Deploy to Google Play Store automatically
- Create or manage Firebase Console resources directly
- Access your keystore/passwords (stored as GitHub secrets)

---

## Best Practices

### Prompting Hermes

Be specific and provide context:

```
✗ "Fix the error"
✓ "Fix the Firebase Auth error in OtpScreen where OTP verification times out on slow networks"
```

### Reviewing Agent Output

1. Always verify generated code with `flutter analyze`
2. Review security rules generated for Firebase
3. Test RTL layout manually after screen changes
4. Verify translations are culturally appropriate for Sudan

### Quality Checks

The agent runs these automatically after every change:
- [x] `flutter analyze` — zero warnings
- [x] `flutter test` — all tests pass
- [x] `dart format .` — consistent formatting
- [x] Firebase rules syntax check (if changed)

---

## Troubleshooting

| Issue | Solution |
|:------|:---------|
| Agent stops mid-task | Run `hermes restart` to recover session |
| Outdated context | Run `hermes sync` to refresh project state |
| Build cache issues | The agent will run `flutter clean` automatically |
| Firebase config missing | Agent runs `flutterfire configure` |
| RTL layout broken | Agent checks `Directionality` and `textDirection` properties |

---

## Version

| Component | Version |
|:----------|:--------|
| **Hermes Agent** | 1.0+ |
| **Flutter** | 3.44+ |
| **Dart** | 3.12+ |
| **Tawali App** | 1.0.0 |

---

## Contact

For Hermes Agent issues: [Hermes Agent Documentation](https://hermes-agent.nousresearch.com/docs)
For Tawali App issues: **mail2mualimx@gmail.com**