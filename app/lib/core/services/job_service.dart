import 'package:app/core/services/_endpoint.dart';

class JobService {
  static const String url = '$BASE_URL/jobs';

  static Future<List<Map<String, dynamic>>> getAllJobs() async {
    return await request(
      url,
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> getJobById(int id) async {
    return await request(
      '$url/get-by-id?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getJobsByEmployer(int id) async {
    return await request(
      '$url/get-by-employer?id=$id',
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> getSavedJobByUserJob(int userId, int jobId) async {
    return await request(
      '$url/get-saved-job-by-user-job?userId=$userId&jobId=$jobId',
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> createJob(Map<String, dynamic> job) async {
    return await request(
      '$url/create',
      method: 'POST',
      body: job
    );
  }

  static Future<Map<String, dynamic>> saveJob(int userId, int jobId) async {
    return await request(
      '$url/save-job?userId=$userId&jobId=$jobId',
      method: 'POST',
    );
  }

  static Future<Map<String, dynamic>> updateJob(Map<String, dynamic> job) async {
    return await request(
      '$url/update',
      method: 'PATCH',
      body: job
    );
  }

  static Future<Map<String, dynamic>> deleteJob(int id) async {
    return await request(
      '$url/delete?id=$id',
      method: 'DELETE'
    );
  }
}