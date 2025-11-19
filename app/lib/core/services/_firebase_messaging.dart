import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getDeviceFcmToken() async {
  return await FirebaseMessaging.instance.getToken();
}
