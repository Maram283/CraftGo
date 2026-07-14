import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android emulator, or your machine's IP for physical device.
  // Using localhost/127.0.0.1 for Web/Windows.
  static const String baseUrl = 'http://localhost:5000/api';
  
  static Future<String?> getToken() async {
    return await SessionService.getToken();
  }

  static Future<void> saveToken(String token) async {
    // This is handled by saveSession now, but keeping for compatibility if used directly
  }

  static Future<void> saveUserRole(String role) async {
    // This is handled by saveSession now, but keeping for compatibility if used directly
  }

  static Future<String?> getUserRole() async {
    return await SessionService.getRole();
  }

  static Future<void> logout() async {
    await SessionService.clearSession();
  }

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        await SessionService.saveSession(
          userId: user['id']?.toString() ?? '',
          name: user['name'] ?? '',
          email: user['email'] ?? '',
          role: user['role'] ?? '',
          token: data['token'] ?? '',
        );
        return user;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> signup(String name, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        await SessionService.saveSession(
          userId: user['id']?.toString() ?? '',
          name: user['name'] ?? '',
          email: user['email'] ?? '',
          role: user['role'] ?? '',
          token: data['token'] ?? '',
        );
        return user;
      }
      return null;
    } catch (e) {
      print('Signup error: $e');
      return null;
    }
  }
}