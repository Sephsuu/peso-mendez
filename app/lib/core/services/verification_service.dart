import 'package:app/core/services/_endpoint.dart';

class VerificationService {
  static const String url = '$BASE_URL/verifications';

  static Future<List<Map<String, dynamic>>> getVerificationsByRole(String role) async {
    return await request(
      '$url?role=$role',
      method: 'GET',
    );
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