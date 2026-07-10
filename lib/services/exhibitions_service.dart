import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ExhibitionsService {
  static Future<List<dynamic>> getAllExhibitions() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/exhibitions'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Fetch exhibitions error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> registerForExhibition(String exhibitionId, String craftsmanId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/exhibitions/$exhibitionId/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'craftsmanId': craftsmanId}),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }
}