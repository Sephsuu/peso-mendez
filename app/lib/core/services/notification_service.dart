import 'package:app/core/services/_endpoint.dart';

class NotificationService {
  static const String url = '$BASE_URL/notifications';

  static Future<List<Map<String, dynamic>>> getNotificationsByRole(Map<String, dynamic> notif) async {
    return await request(
      '$url/get-by-role',
      method: 'POST',
      body: notif
    );
  }

  static Future<Map<String, dynamic>> createNotification(Map<String, dynamic> notif) async {
    return await request(
      '$url/create',
      method: 'POST',
      body: notif
    );
  }

}