import 'package:app/core/services/_endpoint.dart';

class MessageService {
  static const String url = '$BASE_URL/messages';

  static Future<List<Map<String, dynamic>>> getConversations(int userId) async {
    return await request(
      '$url/get-conversations?userId=$userId',
      method: 'GET',
    );
  }

  static Future<List<Map<String, dynamic>>> getMessages(int userId, otherId) async {
    return await request(
      '$url/get-messages?userId=$userId&otherId=$otherId',
      method: 'GET',
    );
  }

  static Future<Map<String, dynamic>> createMessage(Map<String, dynamic> message) async {
    return await request(
      '$url/create',
      method: 'POST',
      body: message
    );
  }

}