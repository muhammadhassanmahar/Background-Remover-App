import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // ✅ for kIsWeb
import 'package:http/http.dart' as http;
import '../utills/app_constants.dart';

class ApiService {
  /// Remove background from image using RapidAPI
  /// On Mobile: [imageFilePath] (String path)
  /// On Web: [imageBytes] (Uint8List)
  static Future<Uint8List?> removeBackground({
    String? imageFilePath,
    Uint8List? imageBytes,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${AppConstants.apiUrl}/remove-background"),
      );

      // ✅ Add headers
      request.headers.addAll({
        "x-rapidapi-key": AppConstants.apiKey,
        "x-rapidapi-host": AppConstants.apiHost,
      });

      // ✅ Mobile/Desktop: use file path
      if (!kIsWeb && imageFilePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image_file", imageFilePath),
        );
      }

      // ✅ Web: use Uint8List
      if (kIsWeb && imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            "image_file",
            imageBytes,
            filename: "upload.png",
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.toBytes(); // ✅ works for both
      } else {
        throw Exception("Failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error removing background: $e");
    }
  }
}
