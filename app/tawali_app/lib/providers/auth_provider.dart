import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _verificationId;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get verificationId => _verificationId;

  /// Simuliert Firebase Auth OTP-Sendung
  Future<void> sendOtp(String phone) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _verificationId =
        'verification_id_${DateTime.now().millisecondsSinceEpoch}';
    _isLoading = false;
    notifyListeners();
  }

  /// Simuliert OTP-Verifikation (jeder 6-stellige Code gilt)
  Future<bool> verifyOtp(String code) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (code.length == 6 && RegExp(r'^\d{6}$').hasMatch(code)) {
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phone: '0912345678',
        name: '',
      );
      await _saveUserToPrefs();
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Simuliert Profil-Update
  Future<void> updateProfile(String name, {String? email}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email ?? _currentUser!.email,
      );
      await _saveUserToPrefs();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Löscht den aktuellen User und entfernt ihn aus SharedPreferences
  void logout() {
    _currentUser = null;
    _verificationId = null;
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(AppConstants.prefUserId);
    });
    notifyListeners();
  }

  /// Lädt den User aus SharedPreferences
  Future<void> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.prefUserId);
    if (userJson != null && userJson.isNotEmpty) {
      try {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        _currentUser = UserModel.fromJson(map);
        notifyListeners();
      } catch (_) {
        // JSON fehlerhaft -> ignorieren
      }
    }
  }

  Future<void> _saveUserToPrefs() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.prefUserId,
        jsonEncode(_currentUser!.toJson()),
      );
    }
  }
}