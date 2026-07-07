import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator → 10.0.2.2 = your laptop's localhost
  // Physical device  → your laptop's local IP e.g. 192.168.1.xx:5000
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  static const Duration _timeout = Duration(seconds: 15);

  static Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // ── AUTH ─────────────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(_timeout);
    return _handle(res);
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'customer',
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers(),
      body: jsonEncode({
        'email': email,
        'password': password,
        'full_name': fullName,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        'role': role,
      }),
    ).timeout(_timeout);
    return _handle(res);
  }

  // ── CATEGORIES ───────────────────────────────────────────────────────────────

  static Future<List<dynamic>> getCategories() async {
    final res = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: _headers(),
    ).timeout(_timeout);
    final body = _handle(res);
    return body['categories'] as List<dynamic>;
  }

  // ── PRODUCTS ─────────────────────────────────────────────────────────────────

  static Future<List<dynamic>> getProducts({
    String? categoryId,
    String? search,
    String sort = 'rating', // rating | newest | price_low | price_high
    int limit = 20,
    int offset = 0,
  }) async {
    final params = {
      'sort': sort,
      'limit': '$limit',
      'offset': '$offset',
      if (categoryId != null) 'categoryId': categoryId,
      if (search != null && search.isNotEmpty) 'search': search,
    };
    final uri = Uri.parse('$baseUrl/products').replace(queryParameters: params);
    final res = await http.get(uri, headers: _headers()).timeout(_timeout);
    final body = _handle(res);
    return body['products'] as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getProductById(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: _headers(),
    ).timeout(_timeout);
    final body = _handle(res);
    return body['product'] as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getProductsByArtisan(String artisanId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/products/artisan/$artisanId'),
      headers: _headers(),
    ).timeout(_timeout);
    final body = _handle(res);
    return body['products'] as List<dynamic>;
  }

  // ── Response handler ─────────────────────────────────────────────────────────

  static Map<String, dynamic> _handle(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw ApiException(body['error'] ?? 'Error ${res.statusCode}', res.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  const ApiException(this.message, this.statusCode);
  @override
  String toString() => 'ApiException($statusCode): $message';
}