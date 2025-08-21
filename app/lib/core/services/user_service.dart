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
    return await request(
      '$url/create-job-ref',
      method: 'POST',
      body: jobRef
    );
  }

  static Future<Map<String, dynamic>> createLanguageProfeciency(Map<String, dynamic> languageProf) async {
    return await request(
      '$url/create-language-prof',
      method: 'POST',
      body: languageProf
    );
  }

  static Future<Map<String, dynamic>> createEducationalBackground(Map<String, dynamic> edugBg) async {
    return await request(
      '$url/create-educ-bg',
      method: 'POST',
      body: edugBg
    );
  }

  static Future<Map<String, dynamic>> createTechVocTraining(Map<String, dynamic> techVoc) async {
    return await request(
      '$url/create-techvoc-training',
      method: 'POST',
      body: techVoc
    );
  }

  static Future<Map<String, dynamic>> createEligibility(Map<String, dynamic> eligibility) async {
    return await request(
      '$url/create-eligibility',
      method: 'POST',
      body: eligibility
    );
  }

  static Future<Map<String, dynamic>> createProfessionalLicense(Map<String, dynamic> prc) async {
    return await request(
      '$url/create-prof-license',
      method: 'POST',
      body: prc
    );
  }

  static Future<Map<String, dynamic>> createWorkExperience(Map<String, dynamic> workExp) async {
    return await request(
      '$url/create-work-exp',
      method: 'POST',
      body: workExp
    );
  }

  static Future<Map<String, dynamic>> createOtherSkill(Map<String, dynamic> otherSkill) async {
    return await request(
      '$url/create-other-skill',
      method: 'POST',
      body: otherSkill
    );
  }

  static Future<Map<String, dynamic>> deactivateUser(int id) async {
    return await request(
      '$url/deactivate?id=$id',
      method: 'PATCH',
    );
  }

}