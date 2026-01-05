import 'dart:convert';

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

  static Future<Map<String, dynamic>> getVerificationByUser(int id) async {
    return await request(
      '$url/get-by-user?id=$id',
      method: 'GET',
    );
  }

  static Future<List<Map<String, dynamic>>> getAllEmployers() async {
    return await request(
      '$url/get-all-users',
      method: 'GET',
    );
  }

  static Future<Map<String, dynamic>> uploadDocuments(File file) async {
    try {
      final uri = Uri.parse('$BASE_URL/uploads/job-seeker/resume');
      final request = http.MultipartRequest('POST', uri);

      final stream = http.ByteStream(file.openRead());
      final length = await file.length();

      request.files.add(
        http.MultipartFile(
          'document',
          stream,
          length,
          filename: path.basename(file.path),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        final Map<String, dynamic> jsonRes = jsonDecode(responseBody);

        // final String? filePath = jsonRes['filePath'];

        return jsonRes;
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

  static Future<Map<String, dynamic>> updateVerification(
    int id,
    Map<String, dynamic> verification,
  ) async {
    return await request(
      '$url/update',
      method: 'POST',
      body: {
        ...verification,
        "id": id, 
      },
    );
  }


  static Future<Map<String, dynamic>> updateVerificationStatus(id, status, String note) async {
    return await request(
      '$url/update-status?id=$id&status=$status',
      method: 'PATCH',
      body: { "note": note }
    );
  }
}