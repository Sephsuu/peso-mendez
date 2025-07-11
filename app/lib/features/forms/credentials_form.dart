import 'dart:convert';

import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/core/components/button.dart';


class RegisterForm extends StatefulWidget {
  final VoidCallback onNext;

  const RegisterForm({super.key, required this.onNext});

  @override 
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? _role;
  final List<Map<String, String>> roles = [
    {'label': 'Employer', 'value': 'employer'},
    {'label': 'Job Seeker', 'value': 'job_seeker'},
  ];

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _contact.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final fullNameValue = _fullName.text.trim();
      final emailValue = _email.text.trim();
      final contactValue = _contact.text.trim();
      final usernameValue = _username.text.trim();
      final passwordValue = _password.text.trim();
      final roleValue = _role;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait. We are registering your credentials.'))
      );

      try {
        final url = Uri.parse('https://x848qg05-3005.asse.devtunnels.ms/auth/register');

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'fullName': fullNameValue,
            'email': emailValue,
            'contactNumber': contactValue,
            'username': usernameValue,
            'password': passwordValue,
            'role': roleValue
          })
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You are successfully registered. Please fill up the following forms.'))
          );

          widget.onNext();
        } else {
          final errorData = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${errorData['error']}')),
          );
        }
      } catch (e) {
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
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 30.0),
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
                  child: Text('Create Your Account', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                ),
                const SizedBox(height: 5.0),
                SizedBox(
                  width: double.infinity,
                  child: Text('Job seekers and employers can register here.', textAlign: TextAlign.center, style: AppText.textMuted.merge(AppText.textXs)),
                ),
                const SizedBox(height: 10.0),
                Text('Full Name', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                TextFormField(
                  controller: _fullName,
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
                Text('E-mail Address', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                TextFormField(
                  controller: _email,
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
                      return 'Please enter your e-mail address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Text('Contact Number', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                TextFormField(
                  controller: _contact,
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
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Text('Username', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                TextFormField(
                  controller: _username,
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
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                Text('Password', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                TextFormField(
                  obscureText: true,
                  controller: _password,
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
                const SizedBox(height: 8.0),
                Text('I am a:', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                DropdownButtonFormField<String>(
                  value: _role,
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role['value'],       
                      child: Text(role['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _role = value;
                      print(_role); // prints 'employer' or 'job_seeker'
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Role',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                    ),
                    isDense: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null; // Add this to explicitly indicate validation passed
                  },
                ),
                const SizedBox(height: 20.0),
                RegisterNextButton(registerUser: _submitForm),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      child: Text('Sign in', style: AppText.textPrimary),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(onNavigate: (page) => globalNavigateTo?.call(page)),
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