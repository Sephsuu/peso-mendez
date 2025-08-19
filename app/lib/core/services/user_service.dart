import 'package:app/core/services/_endpoint.dart';

class UserService {
  static const String url = "https://x848qg05-3005.asse.devtunnels.ms/users";

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await request(
      url,
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> getUserById(int id) async {
    return await request(
      '$url/get-by-id?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getUserByRole(String role) async {
    return await request(
      '$url/get-by-role?role=$role',
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> createPersonalInformation(Map<String, dynamic> personalInfo) async {
    return await request(
      '$url/create-personal-info',
      method: 'POST',
      body: personalInfo
    );
  }

  static Future<Map<String, dynamic>> createJobReference(Map<String, dynamic> jobRef) async {
    print(jobRef);
    return await request(
      '$url/create-job-ref',
      method: 'POST',
      body: jobRef
    );
  }

  static Future<Map<String, dynamic>> deactivateUser(int id) async {
    return await request(
      '$url/deactivate?id=$id',
      method: 'PATCH',
    );
  }

}