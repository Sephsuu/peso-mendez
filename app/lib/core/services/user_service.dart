import 'package:app/core/services/_endpoint.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';


class UserService {
  static const String url = "$BASE_URL/users";

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

  static Future<double> getUserProfileStrength(int id) async {
    final profileStrength = await request(
      '$url/get-profile-strength?id=$id',
      method: 'GET'
    );
    return  (profileStrength as num).toDouble();
  }

  static Future<Map<String, dynamic>> getUserCredential(int id) async {
    return await request(
      '$url/get-credentials?id=$id',
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> getUserPersonalInformation(int id) async {
    return await request(
      '$url/get-personal-information?id=$id',
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> getUserJobReference(int id) async {
    return await request(
      '$url/get-job-reference?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getUserLanguageProfeciency(int id) async {
    return await request(
      '$url/get-language-profeciency?id=$id',
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> getUserEducationalBackground(int id) async {
    return await request(
      '$url/get-educational-background?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getUserTechVocTrainings(int id) async {
    return await request(
      '$url/get-tech-voc-trainings?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getUserEligibility(int id) async {
    return await request(
      '$url/get-eligibility?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getUserProfLicense(int id) async {
    return await request(
      '$url/get-prof-license?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getUserWorkExperience(int id) async {
    return await request(
      '$url/get-work-experience?id=$id',
      method: 'GET'
    );
  }

  static Future<List<Map<String, dynamic>>> getUserOtherSkills(int id) async {
    return await request(
      '$url/get-other-skills?id=$id',
      method: 'GET'
    );
  }

  static Future<Map<String, dynamic>> getEmployerInformation(int id) async {
    return await request(
      '$url/get-employer-information?id=$id',
      method: 'GET'
    );
  }

  static Future<Uint8List> generateResume(int id) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/users/generate-resume?id=$id'),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // ✅ PDF bytes
    } else {
      throw Exception('Failed to generate resume');
    }
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

  static Future<Map<String, dynamic>> createEmployerInformation(Map<String, dynamic> employerInfo) async {
    return await request(
      '$url/create-employer-information',
      method: 'POST',
      body: employerInfo
    );
  }

  static Future<Map<String, dynamic>> updateUserCredential(Map<String, dynamic> user) async {
    return await request(
      '$url/update-credential',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserPersonalInformation(Map<String, dynamic> user) async {
    return await request(
      '$url/update-personal-info',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserJobReference(Map<String, dynamic> user) async {
    return await request(
      '$url/update-job-ref',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserLanguageProficiency(Map<String, dynamic> user) async {
    return await request(
      '$url/update-language',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserEducationalBackground(Map<String, dynamic> user) async {
    return await request(
      '$url/update-educ-bg',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserTechVocTraining(Map<String, dynamic> user) async {
    return await request(
      '$url/update-techvoc-training',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserEligibility(Map<String, dynamic> user) async {
    return await request(
      '$url/update-eligibility',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserProfessionalLicense(Map<String, dynamic> user) async {
    return await request(
      '$url/update-prof-license',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserWorkExperience(Map<String, dynamic> user) async {
    return await request(
      '$url/update-work-exp',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateUserOtherSkills(Map<String, dynamic> user) async {
    return await request(
      '$url/update-other-skills',
      method: 'PATCH',
      body: user
    );
  }

  static Future<Map<String, dynamic>> updateEmployerInformation(Map<String, dynamic> user) async {
    return await request(
      '$url/update-employer-information',
      method: 'POST',
      body: user
    );
  }

  static Future<Map<String, dynamic>> deactivateUser(int id, String reason) async {
    return await request(
      '$url/deactivate?id=$id',
      method: 'PATCH',
      body: { "note": reason }
    );
  }

}