import 'package:app/core/services/_endpoint.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;


class VerificationService {
  static const String url = '$BASE_URL/verifications';

  static Future<List<Map<String, dynamic>>> getVerificationsByRole(String role) async {
    return await request(
      '$url?role=$role',
      method: 'GET',
    );
  }

  static Future<String?> uploadEmployerDocuments(File file) async {
    try {
      final uri = Uri.parse('$BASE_URL/uploads/employer-docs');
      print(uri);
      final request = http.MultipartRequest('POST', uri);

      final stream = http.ByteStream(file.openRead());
      final length = await file.length();

      request.files.add(
        http.MultipartFile(
          'file',
          stream,
          length,
          filename: path.basename(file.path),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        // Expected backend return: {"filePath": "uploads/employer-documents/file_123.pdf"}
        final cleanPath = responseBody
            .replaceAll('"', '')
            .replaceAll('{filePath:', '')
            .replaceAll('}', '')
            .trim();

        return cleanPath;
      } else {
        throw Exception('Upload failed with code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('UploadService error: $e');
    }
  }

  static Future<Map<String, dynamic>> createVerification(verification) async {
    return await request(
      '$url/create',
      method: 'POST',
      body: verification
    );
  }

  static Future<Map<String, dynamic>> updateVerificationStatus(id, status) async {
    return await request(
      '$url/update-status?id=$id&status=$status',
      method: 'PATCH',
    );
  }
}