import 'package:app/core/services/_endpoint.dart';

class TokenService {
  static const String url = "$BASE_URL/tokens";

  static Future<Map<String, dynamic>> saveFCMToken(Map<String, dynamic> token) async {
    return await request(
      '$url/save-fcm-token',
      method: 'POST',
      body: token
    );
  }
}