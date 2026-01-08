import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = "dx7htpnaj"; //  Cloud Name
  static const String uploadPreset = "flutter_unsigned"; //  unsigned preset

  static Future<String?> uploadImage(File image) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      final data = jsonDecode(res);
      return data['secure_url']; // Cloudinary image URL
    } else {
      return Future.error("Upload failed: ${response.statusCode}");
    }
  }
}
