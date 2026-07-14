import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ProductsService {
  static Future<List<dynamic>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/products'));
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) { return []; }
  }

  static Future<bool> createProduct({
    required String craftsmanId,
    required String titleAr,
    required String titleEn,
    required String description,
    required double price,
    required String category,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'craftsmanId': craftsmanId,
          'titleAr': titleAr,
          'titleEn': titleEn,
          'description': description,
          'price': price,
          'category': category,
        }),
      );
      return response.statusCode == 201;
    } catch (e) { return false; }
  }

  static Future<bool> placeOrder({
    required String customerId,
    required String productId,
    required String deliveryAddress,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customerId': customerId,
          'productId': productId,
          'deliveryAddress': deliveryAddress,
        }),
      );
      return response.statusCode == 201;
    } catch (e) { return false; }
  }

  static Future<List<dynamic>> getUserOrders(String userId) async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/orders/$userId'));
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) { return []; }
  }
}