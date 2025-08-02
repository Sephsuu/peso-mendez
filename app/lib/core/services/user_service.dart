import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:app/features/forms/login.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
class UserService {
  static const _secureStorage = FlutterSecureStorage();
  static const String _baseUrl = "https://x848qg05-3005.asse.devtunnels.ms";

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

  static Future<Map<String, dynamic>> fetchLoggedUserData() async {
    final url = Uri.parse('$_baseUrl/auth/dashboard');
    final token = await _secureStorage.read(key: 'jwt_token');
    
    if (token == null) {
      throw Exception("Failed to load user data. Please re-log in your account");
    }
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];
      return user;
    } else {
      throw Exception("Failed to load user data. Please re-log in your account");
    }
  }
  
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    final url = Uri.parse('$_baseUrl/users');

    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Map<String, dynamic>> data = jsonList.cast<Map<String, dynamic>>();
        return data;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    });
  }

  static Future<Map<String, dynamic>> fetchUserById(int userId) async {
    final url = Uri.parse('$_baseUrl/users/$userId');

    try {
      final token = await _secureStorage.read(key: 'jwt_token');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',  // Add the JWT token here
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;  // Assuming the API returns the user object directly
      } else {
        throw Exception('Something went wrong.');
      }
    } catch (e) {
      throw Exception('Something went wrong.');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUserByRole(String role) async {
    final url = Uri.parse('$_baseUrl/users/role/$role');

    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<Map<String, dynamic>> data = jsonList.cast<Map<String, dynamic>>();
        return data;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    });
  }

  static Future<Map<String, dynamic>> fetchUsersCount(String table) async {
    final url = Uri.parse('$_baseUrl/users/count/$table');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}