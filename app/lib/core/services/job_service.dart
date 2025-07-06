import 'dart:convert';
import 'package:app/models/models.dart';
import 'package:http/http.dart' as http;

class JobService {
  static const String _baseUrl = 'https://x848qg05-3005.asse.devtunnels.ms/jobs';

  static Future<List<Map<String, dynamic>>> fetchJobs() async {
    final url = Uri.parse(_baseUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Map<String, dynamic>> data = jsonList.cast<Map<String, dynamic>>();
      return data;
    } else {
      throw Exception('Failed to load jobs: ${response.statusCode}');
    }
  }

  static Future<Job> fetchJobById(int jobId) async {
    final url = Uri.parse('$_baseUrl/$jobId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Job.fromJson(data);
    } else {
      throw Exception('Failed to load job with id $jobId');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchJobsByEmployer(int employerId) async {
    final url = Uri.parse('$_baseUrl/employer-jobs/$employerId'); 
    print(url); 
    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Map<String, dynamic>> data = jsonList.cast<Map<String, dynamic>>();
        return data;
      } else {
        throw Exception("Failed to fetch jobs by the logged employer");
      }
    });
  }

  static Future<int> fetchJobCountByEmployer(int employerId) async {
    final url = Uri.parse('$_baseUrl/jobs/employer/count/$employerId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['count'] as int;
    } else {
      throw Exception('Failed to load job count for employer $employerId');
    }
  }

  static Future<List<String>> getJobTitlesByEmployer(int employerId) async {
    final url = Uri.parse('$_baseUrl/jobs/employer/title/$employerId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load job titles for employer $employerId');
    }
  }

  static Future<List<String>> getJobLocationsByEmployer(int employerId) async {
    final url = Uri.parse('$_baseUrl/jobs/employer/location/$employerId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load job titles for employer $employerId');
    }
  }

  static Future<void> updateJob(Map<String, dynamic> job) async {
    final url = Uri.parse('$_baseUrl/update-job');

    await http.put(
      url,
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode(job)
    );
  }

  static Future<void> deleteJob(int jobId) async {
    final url = Uri.parse('$_baseUrl/delete-job/$jobId');
    await http.delete(url);
  } 
}