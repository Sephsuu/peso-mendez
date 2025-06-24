import 'package:app/core/theme/typography.dart';
import 'package:app/features/login.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

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
  final List<String> roles = ['Employer', 'Job Seeker'];

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _contact.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _nextForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data'))
      );
      widget.onNext();
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
                DropdownButtonFormField(
                  value: _role,
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(), 
                  onChanged: (value) {
                    setState(() {
                      _role = value;
                      print(_role);
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Role',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                    ),
                    isDense: true
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                RegisterNextButton(registerUser: _nextForm),
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