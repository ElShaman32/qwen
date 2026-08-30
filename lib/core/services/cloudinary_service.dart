import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../constants/cloudinary_config.dart';

/// Sube archivos a Cloudinary con upload preset unsigned.
class CloudinaryService {
  static final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  /// Sube el logo y retorna la secure_url, o null si falla.
  /// Sube una imagen (unsigned). folder: 'logos' o 'qr'.
  Future<String?> subirImagen(File archivo, {String folder = 'logos'}) async {
    try {
      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = CloudinaryConfig.uploadPreset
        ..fields['folder'] = folder
        ..files.add(await http.MultipartFile.fromPath('file', archivo.path));

      final response =
          await request.send().timeout(const Duration(seconds: 30));
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final json = jsonDecode(body) as Map<String, dynamic>;
        _logger.i('☁️ Logo subido a Cloudinary');
        return json['secure_url'] as String?;
      }

      _logger.e('❌ Cloudinary ${response.statusCode}: $body');
      return null;
    } catch (e) {
      _logger.e('❌ Error subiendo a Cloudinary: $e');
      return null;
    }
  }
}

final cloudinaryServiceProvider =
    Provider<CloudinaryService>((ref) => CloudinaryService());
