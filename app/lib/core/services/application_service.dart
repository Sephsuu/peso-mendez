import 'dart:convert';
import 'package:http/http.dart' as http;

class ApplicationService {
  static const String _baseUrl = "https://x848qg05-3005.asse.devtunnels.ms/applications";

  static Future<Map<String, dynamic>> submitApplication(int jobId, int userId) async {
    final Map<String, dynamic> bodyData = {
      'jobId': jobId,
      'userId': userId,
    };
      final res = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bodyData),
      );

      if (res.statusCode != 201) {
        return throw Exception('Something went wrong.');
      } 

      return jsonDecode(res.body) as Map<String, dynamic>;
    }
  

  static Future<Map<String, dynamic>> getApplicationByJobAndUser(int jobId, int userId) async {

    final res = await http.get(Uri.parse('$_baseUrl/get-by-job-user/$jobId/$userId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(res.body);
      return data;
    } else if (res.statusCode == 404) {
      return {};
    }
    else {
      throw Exception('Failed to load application for job $jobId and user $userId: ${res.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> getApplicationsByEmployer(int employerId) {
    final url = Uri.parse('$_baseUrl/employer-applications/$employerId');

    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Map<String, dynamic>> data = jsonList.cast<Map<String, dynamic>>();
        return data;
      } else {
        throw Exception('Failed to load applications for employer $employerId: ${response.statusCode}');
      }
    });
  }

  static Future<List<Map<String, dynamic>>> updateApplicationStatus(int applicationId, String status) {
    final url = Uri.parse('$_baseUrl/update-status/$applicationId/$status');
    return http.put(url).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Map<String, dynamic>> data = jsonList.cast<Map<String, dynamic>>();
        return data;
      } else {
        throw Exception('Failed to load $applicationId: ${response.statusCode}');
      }
    });
  }

  static Future<List<Map<String, dynamic>>> getApplicationsByUser(int userId) async {
    final url = Uri.parse('$_baseUrl/job-seeker-applications/$userId');
    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Map<String, dynamic>> data = jsonList.cast<Map<String, dynamic>>();
        return data;
      } else {
        throw Exception('Failed to load $userId: ${response.statusCode}');
      }
    });
  }

}