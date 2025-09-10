import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';

class ApiService {
  static Future<Uint8List?> removeBackground(
      String filePath) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(AppConstants.apiUrl));
      request.headers.addAll({
        'x-rapidapi-key': AppConstants.apiKey,
        'x-rapidapi-host': AppConstants.apiHost,
      });

      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      } else {
        throw Exception("Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
