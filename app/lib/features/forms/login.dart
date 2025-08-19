import 'dart:convert';

import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/features/dashboard/admin.dart';
import 'package:app/features/forms/register.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatelessWidget  {
  final Function(PageType) onNavigate;

  const Login({super.key, required this.onNavigate});

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
  _LoginFormState createState() => _LoginFormState();
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifying credentials...'))
      );

      try {
        final url = Uri.parse('https://x848qg05-3005.asse.devtunnels.ms/auth/login'); // Replace with your backend URL

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

          final token = responseData['token'];
          final user = responseData['user'];
          final role = user != null ? user['role'] : null;
          if (token != null) {
            await _secureStorage.write(key: 'jwt_token', value: token);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged in successfuly!')),
            );

            if (role == 'job_seeker') {
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => JobSeekerDashboard(
                  onNavigate: (page) => globalNavigateTo?.call(page),
                ),
              ));
            } else if (role == 'employer') {
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => EmployerDashboard(
                  onNavigate: (page) => globalNavigateTo?.call(page),
                ),
              ));
            } else if (role == 'admin') {
              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const AdminDashboard(),
              ));
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed: Token missing in response')),
            );
          }
        } else {
          final errorData = jsonDecode(response.body);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${errorData['message']}')),
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
                SignInButton(onPressed: _submitForm),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      child: Text('Register Now', style: AppText.textPrimary),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(onNavigate: (page) => globalNavigateTo?.call(page)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}