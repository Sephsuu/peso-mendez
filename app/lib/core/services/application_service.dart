import 'dart:convert';
import 'package:app/models/models.dart';
import 'package:http/http.dart' as http;

class ApplicationService {
  static const String _baseUrl = "https://x848qg05-3005.asse.devtunnels.ms/applications";

  static Future<void> submitApplication(int jobId, int userId) async {
    final url = Uri.parse(_baseUrl);

    final Map<String, dynamic> bodyData = {
      'jobId': jobId,
      'userId': userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

      } else {

      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error submitting application: $e');
      throw Exception('Failed to submit application');
    }
  }

  static Future<Application> getApplicationByJobAndUser(int jobId, int userId) async {
    final url = Uri.parse('$_baseUrl/$jobId/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Application.fromJson(data);
    } else {
      throw Exception('Failed to load application for job $jobId and user $userId: ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> getApplicationsByEmployer(int employerId) {
    final url = Uri.parse('$_baseUrl/$employerId');

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

  static Future<List<Map<String, dynamic>>> getApplicationsByEmployerFilter(int employerId, String jobTitle, String location, String status) {
    final url = Uri.parse('$_baseUrl/filter/$employerId/$jobTitle/$location/$status');

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

}