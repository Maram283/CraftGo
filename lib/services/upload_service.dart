import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'api_service.dart';
import 'session_service.dart';

/// Handles file/image uploads to the backend.
class UploadService {
  /// Uploads a single image file and returns the public URL or null on failure.
  static Future<String?> uploadImage(File imageFile, {String field = 'image'}) async {
    try {
      final token = await SessionService.getToken();
      final uri = Uri.parse('${ApiService.baseUrl}/upload/image');

      final request = http.MultipartRequest('POST', uri);
      if (token != null) request.headers['Authorization'] = 'Bearer $token';

      final ext = imageFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          field,
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        final data = jsonDecode(body);
        return data['url'] as String?;
      }
      return null;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  /// Uploads multiple images and returns list of URLs.
  static Future<List<String>> uploadImages(List<File> files) async {
    final results = <String>[];
    for (final file in files) {
      final url = await uploadImage(file);
      if (url != null) results.add(url);
    }
    return results;
  }
}
