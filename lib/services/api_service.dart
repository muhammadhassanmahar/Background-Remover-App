import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';

class ApiService {
  /// Remove background from image
  static Future<Uint8List?> removeBackground(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConstants.baseUrl}/remove-background"),
      );

      // Attach image file
      request.files.add(
        await http.MultipartFile.fromPath('image_file', imageFile.path),
      );

      // Headers
      request.headers.addAll({
        "X-RapidAPI-Key": AppConstants.apiKey,
        "X-RapidAPI-Host": AppConstants.apiHost,
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
