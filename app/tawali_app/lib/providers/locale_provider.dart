import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;
  bool get isArabic => _locale.languageCode == 'ar';

  /// Setzt die Sprache und speichert sie in SharedPreferences
  Future<void> setLocale(String languageCode) async {
    if (languageCode != 'ar' && languageCode != 'en') return;
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefLanguage, languageCode);
  }

  /// Lädt die gespeicherte Sprache aus SharedPreferences
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppConstants.prefLanguage);
    if (saved != null && (saved == 'ar' || saved == 'en')) {
      _locale = Locale(saved);
      notifyListeners();
    }
  }
}