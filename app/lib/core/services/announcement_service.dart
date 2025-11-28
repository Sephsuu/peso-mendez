import 'package:app/core/services/_endpoint.dart';

class AnnouncementService {
  static const String url = '$BASE_URL/announcements';

  static Future<List<Map<String, dynamic>>> getAllAnnouncements() async {
    return await request(
      url,
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> createAnnouncement(Map<String, dynamic> announcement) async {
    return await request(
      '$url/create',
      method: 'POST',
      body: announcement
    );
  }

  static Future<List<Map<String, dynamic>>> getAnnouncementsByRole(String role) async {
    return await request(
      '$url/get-by-audience?role=$role',
      method: 'GET'
    );
  }
}