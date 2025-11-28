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

  static Future<Map<String, dynamic>> uploadDocuments(File file, String role) async {
    try {
      final uri = Uri.parse('$BASE_URL/uploads/$role');
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

        // ✅ Decode the JSON response properly
        final Map<String, dynamic> jsonRes = jsonDecode(responseBody);

        // // ✅ Extract only the file path
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
    print('CREATED');
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