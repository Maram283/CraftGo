import 'package:flutter/material.dart';

/// Single source of truth for:
///   • UI prefs  (isArabic, isDarkMode)
///   • Auth state (current user, JWT token)
///
/// Any widget that calls context.watch<AppState>() rebuilds automatically
/// when any of these change — regardless of where it sits in the nav stack.
class AppState extends ChangeNotifier {
  // ── UI preferences ───────────────────────────────────────────────────────────
  bool isArabic = true;
  bool isDarkMode = true;

  void toggleLanguage() {
    isArabic = !isArabic;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  // ── Auth state ────────────────────────────────────────────────────────────────
  String? _token;
  Map<String, dynamic>? _currentUser;
  bool _isGuest = false;

  String? get token => _token;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoggedIn => _token != null && _currentUser != null;
  bool get isGuest => _isGuest;

  String get userName => _currentUser?['full_name'] ?? _currentUser?['email'] ?? 'User';
  String get userEmail => _currentUser?['email'] ?? '';
  String get userRole => _currentUser?['role'] ?? 'customer';
  String get userId => _currentUser?['id'] ?? '';

  void setAuth({required Map<String, dynamic> user, required String token}) {
    _token = token;
    _currentUser = user;
    _isGuest = false;
    notifyListeners();
  }

  void setGuest() {
    _token = null;
    _currentUser = null;
    _isGuest = true;
    notifyListeners();
  }

  void clearAuth() {
    _token = null;
    _currentUser = null;
    _isGuest = false;
    notifyListeners();
  }
}