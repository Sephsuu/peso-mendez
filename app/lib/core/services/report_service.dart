import 'package:app/core/services/_endpoint.dart';

class ReportService {
  static const String url = "$BASE_URL/reports";

  static Future<List<Map<String, dynamic>>> getHighestEducationCounts() async {
    return await request(
      '$url/highest-education',
      method: 'GET',
    );
  }

  static Future<List<Map<String, dynamic>>> getGenderCounts() async {
    return await request(
      '$url/genders',
      method: 'GET',
    );
  }

  static Future<List<Map<String, dynamic>>> getPlacementCounts() async {
    return await request(
      '$url/placements',
      method: 'GET',
    );
  }

  static Future<List<Map<String, dynamic>>> getEmployerTypesCounts() async {
    return await request(
      '$url/employer-types',
      method: 'GET',
    );
  }

  static Future<List<Map<String, dynamic>>> getClienteleCounts() async {
    return await request(
      '$url/clientele',
      method: 'GET',
    );
  }

  static Future<List<Map<String, dynamic>>> getCitmunCounts() async {
    return await request(
      '$url/citmun',
      method: 'GET',
    );
  }
}