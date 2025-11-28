import 'dart:convert';

import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/services/token_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/features/dashboard/admin.dart';
import 'package:app/features/forms/register.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatelessWidget  {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: "Mendez PESO Job Portal", onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            LoginForm(),
            Footer()
          ],
        ),
      )
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override 
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailOrUsername = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _emailOrUsername.dispose();
    _password.dispose();
    super.dispose();
  }

  final _secureStorage = const FlutterSecureStorage();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final emailOrUsernameValue = _emailOrUsername.text.trim();
      final passwordValue = _password.text;
      AppSnackbar.show(
        context, 
        message: 'Verifying Credentials. Please wait.',
        backgroundColor: AppColor.primary
      );

      try {
        final url = Uri.parse('$BASE_URL/auth/login'); // Replace with your backend URL

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'emailOrUsername': emailOrUsernameValue,
            'password': passwordValue,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          await TokenService.saveFCMToken({
            "userId": responseData['user']['id'],
            "token": await FirebaseMessaging.instance.getToken()
          });

          final token = responseData['token'];
          final user = responseData['user'];
          final role = user != null ? user['role'] : null;
          if (responseData['status'] == 'inactive') {
            if (!mounted) return;
            showDialog(
              context: context, 
              builder: (context) {
                return AppModal(
                  title: 'Account is currently deactivated.',
                  message: 'Try to contact PESO Mendez administrator to recover your account.',
                  titleStyle: AppText.fontSemibold.merge(AppText.textLg),
                  confirmLabel: "I understand.",
                  confirmBackground: AppColor.primary,
                  confirmForeground: AppColor.light,
                );
              }
            );
            return;
          }
          if (token != null) {
            await _secureStorage.write(key: 'jwt_token', value: token);
            if (!mounted) return;
            AppSnackbar.show(
              context, 
              message: 'Sucessfully logged in!',
              backgroundColor: AppColor.success
            );

            if (role == 'job_seeker') {
              if (!mounted) return;
              navigateTo(context, const JobSeekerDashboard());
            } else if (role == 'employer') {
              if (!mounted) return;
              navigateTo(context, const EmployerDashboard());
            } else if (role == 'admin') {
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const AdminDashboard(),
              ));
            }
          } else {
            if (!mounted) return;
            AppSnackbar.show(
              context, 
              message: 'Token missing in response.',
              backgroundColor: AppColor.danger
            );
          }
        } else {
          final errorData = jsonDecode(response.body);
          if (!mounted) return;
          AppSnackbar.show(
            context, 
            message: '${errorData["message"]}.',
            backgroundColor: AppColor.danger
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 244, 244, 244),
      padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0, bottom: 250.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text('Sign in to Mendez PESO', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                ),
                const SizedBox(height: 20.0),
                Text('E-mail Address or Username', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                TextFormField(
                  controller: _emailOrUsername,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                    ),
                    labelText: null,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    isDense: true
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Text('Password', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                    ),
                    labelText: null,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    isDense: true
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Sign In', 
                    foregroundColor: AppColor.light,
                    onPressed: () => _submitForm(),
                    visualDensityY: -2,
                  ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center, // keeps children centered
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 5.0),
                      GestureDetector(
                        child: Text('Register Now', style: AppText.textPrimary),
                        onTap: () => navigateTo(context, const Register()),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}