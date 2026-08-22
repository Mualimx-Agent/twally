# Contributing to Tawali (طوالي)

Thank you for considering contributing to **Tawali** — Sudan's food delivery app! We welcome contributions of all kinds: code, design, documentation, translations, and bug reports.

---

## Code of Conduct

By participating, you agree to maintain a **respectful and inclusive** environment:

- Use welcoming and inclusive language
- Be respectful of differing viewpoints
- Accept constructive criticism gracefully
- Focus on what is best for the community and the Sudanese people
- Show empathy towards other community members

---

## Getting Started

### 1. Fork & Clone
```bash
git clone https://github.com/your-username/tawali.git
cd tawali/app/tawali_app
flutter pub get
```

### 2. Set Up Firebase
See [INSTALL.md](INSTALL.md) for detailed Firebase setup instructions.

### 3. Create a Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 4. Development
```bash
# Run on emulator or device
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze
```

### 5. Commit & Push
```bash
git add .
git commit -m "feat: add your feature description"
git push origin your-branch-name
```

### 6. Open a Pull Request
- Target the `main` branch
- Include screenshots for UI changes
- Reference any related issues
- Describe your changes in detail

---

## Development Guidelines

### Code Style
- Follow [Dart's official style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` before committing — zero warnings
- Run `dart format .` before committing
- Maximum line length: **100 characters**
- File names: `snake_case.dart`
- Class names: `PascalCase`
- Variables/Functions: `camelCase`

### Architecture
- Follow the **feature-first** architecture (see [ARCHITECTURE.md](ARCHITECTURE.md))
- Each feature in its own directory under `lib/features/`
- Shared code in `lib/core/` or `lib/services/`
- State management via **Riverpod** providers
- Routing via **go_router**

### Commit Messages
Use [Conventional Commits](https://www.conventionalcommits.org/):
```
feat: add order tracking screen
fix: resolve OTP timeout on slow networks
docs: update installation guide
style: format restaurant card widget
refactor: extract address picker to shared widget
test: add cart provider unit tests
chore: update firebase dependencies
```

### Branch Naming
```
feature/order-tracking
fix/otp-timeout
docs/update-readme
refactor/extract-widgets
```

---

## Pull Request Process

1. **Ensure tests pass** — run `flutter test` before submitting
2. **Ensure zero analysis warnings** — run `flutter analyze`
3. **Update documentation** if adding new features
4. **Add tests** for new functionality
5. **Update CHANGELOG.md** with your changes
6. **Request review** from at least one maintainer
7. **Wait for CI** checks to pass

### PR Title Format
```
feat: brief description of change
```

### PR Description Template
```markdown
## Description
[Describe what this PR does]

## Related Issue
Fixes #[issue_number]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring
- [ ] Test update

## Screenshots
[If UI changes, include before/after screenshots]

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-reviewed my code
- [ ] Added/updated tests
- [ ] Updated documentation
- [ ] No new analysis warnings
- [ ] Tested on Android emulator/device
- [ ] Arabic (RTL) layout verified
```

---

## What to Work On

### Good First Issues
- Fix UI inconsistencies in Arabic RTL layout
- Add loading shimmer animations
- Improve error messages in Arabic
- Write unit tests for providers
- Update string translations

### Feature Requests
See the [Issues](https://github.com/Mualimx-Agent/tawali/issues) tab for open feature requests.

---

## Reporting Bugs

### Bug Report Template
```markdown
**Describe the bug:**
[A clear description of the bug]

**To Reproduce:**
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior:**
[What should happen]

**Screenshots:**
[If applicable]

**Environment:**
- Device: [e.g., Samsung Galaxy S24]
- Android version: [e.g., 14]
- App version: [e.g., 1.0.0]
- Language: [Arabic / English]

**Additional context:**
[Any other relevant information]
```

---

## Translation / Localization

We welcome improvements to Arabic translations and new language support.

### Arabic Translation Files
All user-facing strings are in `lib/core/constants/app_strings.dart`.

To add a new string:
1. Add the English version
2. Add the Arabic translation (نسخة عربية)
3. Add any additional locale keys

### Adding a New Language
1. Add locale to `supportedLocales` in `main.dart`
2. Add localization delegates
3. Create string constants for the new locale
4. Add language option to `LanguageScreen`

---

## Testing

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/providers/cart_provider_test.dart

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
```

### Test Categories
- **Unit tests:** Providers, models, utilities
- **Widget tests:** Individual screens and widgets
- **Integration tests:** Full user flows (coming soon)

---

## Project Structure

```
tawali/
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
├── .github/
│   └── workflows/
│       └── deploy.yml
└── app/
    └── tawali_app/
        ├── lib/
        │   ├── main.dart
        │   ├── core/
        │   ├── features/
        │   ├── models/
        │   ├── providers/
        │   ├── services/
        │   ├── theme/
        │   └── router/
        ├── test/
        ├── android/
        ├── ios/
        ├── web/
        └── pubspec.yaml
```

---

## Questions?

- **Email:** mail2mualimx@gmail.com
- **Issues:** [GitHub Issues](https://github.com/Mualimx-Agent/tawali/issues)

---

## Thank You!

Every contribution, no matter how small, helps bring food delivery to the people of Sudan. شكراً جزيلاً! (Thank you very much!)