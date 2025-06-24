import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/register.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 244, 244, 244),
      padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0, bottom: 120.0),
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
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Text('Password', textAlign: TextAlign.start, style: AppText.textSm),
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
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                const SignInButton(),
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
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}