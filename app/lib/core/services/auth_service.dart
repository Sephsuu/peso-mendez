import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class AuthService {
  static const _secureStorage = FlutterSecureStorage();
  static const String url = "$BASE_URL/auth";

  static Future<Map<String, dynamic>> register(Map<String, dynamic> credentials) async {
    return await request(
      '$url/register',
      method: 'POST',
      body: credentials
    );
  }
  
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

  static Future<Map<String, dynamic>> changePassword(Map<String, dynamic> user) async {
    return await request(
      '$url/update-password',
      method: 'POST',
      body: user
    );
  }

  static Future<void> logout(BuildContext context) async {
    await _secureStorage.delete(key: 'jwt_token');
    if (!context.mounted) return;
    AppSnackbar.show(
      context,
      message: 'Sucessfully logged out.',
      backgroundColor: AppColor.success
    );
    navigateTo(context, const Login());
  }

  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await request(
      '$url/forgot-password',
      method: 'POST',
      body: { "email": email }
    );
  }

  
}