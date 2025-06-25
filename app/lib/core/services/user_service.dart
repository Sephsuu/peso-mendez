import 'dart:convert';
import 'package:app/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:app/features/login.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
class UserService {
  static const _secureStorage = FlutterSecureStorage();

  static Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) return false;

    return true;
  }

  static Future<void> logout(BuildContext context) async {
    await _secureStorage.delete(key: 'jwt_token');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully logged out.')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Login(onNavigate: (page) => globalNavigateTo?.call(page)),
      ),
      (route) => false, // Clear all previous routes
    );
  }

  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'jwt_token');
  }

  static Future<Map<String, dynamic>?> fetchLoggedUserData() async {
    final url = Uri.parse('https://x848qg05-3005.asse.devtunnels.ms/auth/dashboard');

    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      if (token == null) {
        return null;
      }
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add the JWT token here
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<User?> fetchUserById(int userId) async {
    final url = Uri.parse('https://x848qg05-3005.asse.devtunnels.ms/users/$userId');

    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      if (token == null) {
        return null;
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add the JWT token here
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);  // Assuming the API returns the user object directly
      } else {
        // Optionally handle different status codes here
        return null;
      }
    } catch (e) {
      // Optionally log the error
      return null;
    }
  }
}