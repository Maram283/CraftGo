import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AuthService {
  // Send OTP to email
  static Future<bool> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending OTP: $e');
      return false;
    }
  }

  // Verify OTP
  static Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error verifying OTP: $e');
      return false;
    }
  }

  // Signup user
  static Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String city,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'city': city,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error during signup: $e');
      return false;
    }
  }
}

