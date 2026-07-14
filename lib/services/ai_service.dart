import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AiService {
  // Generate professional apology letter using Gemini AI
  static Future<String?> generateApology({
    required String craftsmanName,
    required String exhibitionName,
    required String reason,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/ai/generate-apology'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'craftsmanName': craftsmanName,
          'exhibitionName': exhibitionName,
          'reason': reason,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // AI Standby Matching - find best replacement
  static Future<Map<String, dynamic>?> matchStandby(String exhibitionId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/ai/match-standby/$exhibitionId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // AI Bio Validation - check if bio is appropriate and professional
  static Future<Map<String, dynamic>?> validateBio({
    required String bio,
    required String craftCategory,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/ai/validate-bio'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bio': bio,
          'craftCategory': craftCategory,
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}