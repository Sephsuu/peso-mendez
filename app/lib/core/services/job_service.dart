import 'dart:convert';
import 'package:app/models/models.dart';
import 'package:http/http.dart' as http;

class JobService {
  static const String _baseUrl = 'https://x848qg05-3005.asse.devtunnels.ms';

  static Future<List<Job>> fetchJobs() async {
    final url = Uri.parse('$_baseUrl/jobs');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load jobs: ${response.statusCode}');
    }
  }

  static Future<Job> fetchJobById(int jobId) async {
    final url = Uri.parse('$_baseUrl/jobs/$jobId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Job.fromJson(data);
    } else {
      throw Exception('Failed to load job with id $jobId');
    }
  }
}