import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AdminService {
  static Future<Map<String, dynamic>?> getStats() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/admin/stats'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Fetch admin stats error: $e');
      return null;
    }
  }
}
