import 'package:app/core/services/_endpoint.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class AuthService {
  static const _secureStorage = FlutterSecureStorage();
  static const String url = "$BASE_URL/auth";
  
  static Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) return false;
    return true;
  }

  static Future<Map<String, dynamic>> getClaims() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    return await request(
      '$url/get-claims',
      method: 'GET',
      customHeader: { 'Authorization': 'Bearer $token' } 
    );
  }

  static Future<void> logout(BuildContext context) async {
    await _secureStorage.delete(key: 'jwt_token');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully logged out.')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Login(onNavigate: (page) => globalNavigateTo?.call(page))),
      (_) => false,
    );
  }

  
}