import 'dart:convert';

import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/services/auth_service.dart';
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

class _LoginFormState extends State<LoginForm> with RouteAware {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUsername = TextEditingController();
  final _password = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  bool _claimsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadClaims();
  }

  Future<void> _loadClaims() async {
    try {
      final claims = await AuthService.getClaims();

      if (!mounted) return;

      final role = claims['role'];

      if (role == 'job_seeker') {
        navigateTo(context, const JobSeekerDashboard());
      } else if (role == 'employer') {
        navigateTo(context, const EmployerDashboard());
      } else if (role == 'admin') {
        navigateTo(context, const AdminDashboard());
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _claimsLoaded = true;
        });
      }
    }
  }


  @override
  void dispose() {
    _emailOrUsername.dispose();
    _password.dispose();
    super.dispose();
  }


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
                  message: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Reason:', style: AppText.fontSemibold),
                      Text(responseData["note"] ?? "Reason not specified.", style: AppText.textDanger)
                    ],
                  ),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const JobSeekerDashboard()),
                (route) => false,
              );
            } else if (role == 'employer') {
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const EmployerDashboard()),
                (route) => false,
              );
            } else if (role == 'admin') {
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboard()),
                (route) => false,
              );
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
                Center(child: Image.asset('assets/images/peso-mendez.png', width: 60)),
                SizedBox(
                  width: double.infinity,
                  child: Text('Sign in to Mendez PESO', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                ),
                const SizedBox(height: 20.0),
                Text('E-mail Address or Username', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                AppInputField(
                  label: '',
                  controller: _emailOrUsername,
                  required: true,
                  visualDensityY: 0,
                  textSize: 16,
                  validatorMessage: "Please fill out this field.",
                ),
                const SizedBox(height: 12.0),
                Text('Password', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                AppInputField(
                  label: '',
                  controller: _password,
                  required: true,
                  visualDensityY: 0,
                  textSize: 16,
                  validatorMessage: "Please fill out this field.",
                  obscureText: true,
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
                ),
                const SizedBox(height: 10),
                Center(
                  child: GestureDetector(
                    child: Text('Forgot Password.', style: AppText.textPrimary),
                    onTap: () async {
                      final email = _emailOrUsername.text.trim();

                      if (!email.contains('@') && !email.contains('.')) {
                        return AppSnackbar.show(
                          context, 
                          message: 'Please enter a valid email address.',
                          backgroundColor: AppColor.danger
                        );
                      }

                      if (email.isEmpty) {
                        AppSnackbar.show(
                          context,
                          message: "Please enter your email.",
                          backgroundColor: AppColor.danger,
                        );
                        return;
                      }

                      try {
                        await AuthService.forgotPassword(email);

                        if (!context.mounted) return;
                        AppSnackbar.show(
                          context,
                          message: "If that email exists, a reset link was sent.",
                          backgroundColor: AppColor.success,
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        AppSnackbar.show(
                          context,
                          message: "Failed to send reset email: $e",
                          backgroundColor: AppColor.danger,
                        );
                      }
                    },

                  )
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}