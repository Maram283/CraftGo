import 'package:shared_preferences/shared_preferences.dart';

/// Handles all session persistence: user data, role, and login state.
class SessionService {
  static const _keyUserId    = 'session_user_id';
  static const _keyUserName  = 'session_user_name';
  static const _keyUserEmail = 'session_user_email';
  static const _keyUserRole  = 'session_user_role';
  static const _keyUserCity  = 'session_user_city';
  static const _keyToken     = 'auth_token';

  // ── Save full session after login/signup ──────────────────────────────────
  static Future<void> saveSession({
    required String userId,
    required String name,
    required String email,
    required String role,
    String city = '',
    String token = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId,    userId);
    await prefs.setString(_keyUserName,  name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserRole,  role);
    await prefs.setString(_keyUserCity,  city);
    if (token.isNotEmpty) await prefs.setString(_keyToken, token);
  }

  // ── Read session ──────────────────────────────────────────────────────────
  static Future<Map<String, String?>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId':    prefs.getString(_keyUserId),
      'name':      prefs.getString(_keyUserName),
      'email':     prefs.getString(_keyUserEmail),
      'role':      prefs.getString(_keyUserRole),
      'city':      prefs.getString(_keyUserCity),
      'token':     prefs.getString(_keyToken),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(_keyUserRole);
    return role != null && role.isNotEmpty;
  }

  static Future<String?> getRole()  async => (await getSession())['role'];
  static Future<String?> getName()  async => (await getSession())['name'];
  static Future<String?> getUserId() async => (await getSession())['userId'];
  static Future<String?> getEmail() async => (await getSession())['email'];
  static Future<String?> getToken() async => (await getSession())['token'];

  // ── Clear session on logout ───────────────────────────────────────────────
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyUserCity);
    await prefs.remove(_keyToken);
  }
}
