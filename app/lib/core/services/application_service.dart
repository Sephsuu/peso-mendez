import 'package:app/core/services/_endpoint.dart';

class ApplicationService {
  static const String url = "$BASE_URL/applications";

  static Future<Map<String, dynamic>> getApplicationByJobAndUser(int jobId, int userId) async {
    return await request(
      '$url/get-by-job-user?jobId=$jobId&userId=$userId',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getApplicationsByEmployer(int id) async {
    return await request(
      '$url/get-by-employer?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getApplicationsByUser(int id) async {
    return await request(
      '$url/get-by-user?id=$id',
      method: 'GET'
    ) as List<Map<String, dynamic>>;
  }

  static Future<Map<String, dynamic>> createApplication(int jobId, int userId) async {
    return await request(
      '$url/create?jobId=$jobId&userId=$userId',
      method: 'POST',
    );
  }

  static Future<Map<String, dynamic>> updateApplicationStatus(int id, String status) async {
    return await request(
      '$url/update-status?id=$id&status=$status',
      method: 'PATCH',
    );
  }

  static Future<Map<String, dynamic>> updateApplicationPlacement(int id, String placement) async {
    return await request(
      '$url/update-placement?id=$id&placement=$placement',
      method: 'PATCH',
    );
  }

  static Future<Map<String, dynamic>> deleteApplicationByJobUser(int jobId, int userId) async {
    return await request(
      '$url/delete-by-job-user?jobId=$jobId&userId=$userId',
      method: 'DELETE'
    );
  }

}