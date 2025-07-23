// lib/services/cloudinary_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class CloudinaryService {
  static const String _cloudName = 'dlaijeqfj';
  static const String _uploadPreset = 'flutter_unsigned_upload';

  static Future<String?> uploadImage({required ImageSource source}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) {
        debugPrint('No image selected.');
        return null;
      }

      final imageFile = File(pickedFile.path);
      final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/upload');

      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = _uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final resJson = jsonDecode(resBody);
        final imageUrl = resJson['secure_url'];
        debugPrint('Image uploaded: $imageUrl');
        return imageUrl;
      } else {
        debugPrint('Upload failed: ${response.statusCode}');
        debugPrint('Response: $resBody');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
