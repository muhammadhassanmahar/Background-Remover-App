import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../utills/app_constants.dart';

class ApiService {
  /// Remove background from image
  static Future<Uint8List?> removeBackground(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${AppConstants.baseUrl}/remove-background"),
      );

      // Add headers from AppConstants
      request.headers.addAll({
        "x-rapidapi-key": AppConstants.apiKey,
        "x-rapidapi-host": AppConstants.apiHost,
      });

      // Attach file
      request.files.add(
        await http.MultipartFile.fromPath("image_file", imagePath),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        return bytes; // ✅ API returns Uint8List
      } else {
        throw Exception("Failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error removing background: $e");
    }
  }
}
