import 'package:app/core/services/_endpoint.dart';

class AnnouncementService {
  static const String url = '$BASE_URL/announcements';

  static Future<Map<String, dynamic>> createAnnouncement(Map<String, dynamic> announcement) async {
    return await request(
      '$url/create',
      method: 'POST',
      body: announcement
    );
  }
}