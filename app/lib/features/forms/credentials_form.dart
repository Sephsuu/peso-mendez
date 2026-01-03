import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/employer_information.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/features/forms/personal_information_form.dart';
import 'package:flutter/material.dart';
import 'package:app/core/components/button.dart';


class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override 
  State<RegisterForm> createState() => _RegisterFormState();
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

      if (!emailValue.contains('@') && !emailValue.contains('.')) {
        return AppSnackbar.show(
          context, 
          message: 'Please enter a valid email address.',
          backgroundColor: AppColor.danger
        );
      }

      if (contactValue.length != 11) {
        return AppSnackbar.show(
          context,
          message: "Contact number must be 11 digits long.",
          backgroundColor: AppColor.danger
        );
      }

      if (int.tryParse(contactValue) == null) {
        return AppSnackbar.show(
          context,
          message: "Contact number must only contain numerical characters.",
          backgroundColor: AppColor.danger
        );
      }

      if (usernameValue.length < 8) {
        return AppSnackbar.show(
          context,
          message: "Username must be 8 or more characters long.",
          backgroundColor: AppColor.danger
        );
      }

      final isValidPassword = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$').hasMatch(passwordValue);

      if (!isValidPassword) {
        return AppSnackbar.show(
          context,
          message: "Password must be at least 8 characters and include 1 uppercase letter, 1 number, and 1 special symbol.",
          backgroundColor: AppColor.danger
        );
      }

      AppSnackbar.show(
        context, 
        message: 'Please wait. We are registering your credentials.',
        backgroundColor: AppColor.primary
      );

      try {
        final res = await AuthService.register({
            'fullName': fullNameValue,
            'email': emailValue,
            'contactNumber': contactValue,
            'username': usernameValue,
            'password': passwordValue,
            'role': roleValue
        });

        if (res.isNotEmpty) {
          if (!mounted) return;
          if (roleValue == 'employer') {
            AppSnackbar.show(
              context, 
              message: 'You are successfully registered. Please login to your account using your credentials.',
              backgroundColor: AppColor.success
            );
            navigateTo(context, EmployerInformationForm(employerId: res['userId']));
          } else { 
            AppSnackbar.show(
              context, 
              message: 'Please check your email and verify your account.',
              backgroundColor: AppColor.success,
              durationSeconds: 10,
            );
            navigateTo(context, PersonalInformationForm(userId: res["userId"])); 
          }
        } 
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(
            context,
            message: 'Error ${e}',
            backgroundColor: AppColor.danger,
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
                Center(child: Image.asset('assets/images/peso-mendez.png', width: 60)),
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
                AppInputField(
                  label: '',
                  controller: _fullName,
                  required: true,
                  visualDensityY: 0,
                  textSize: 16,
                  validatorMessage: "Please enter your full name.",
                ),
                const SizedBox(height: 8.0),
                Text('E-mail Address', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                AppInputField(
                  label: '',
                  controller: _email,
                  required: true,
                  visualDensityY: 0,
                  textSize: 16,
                  validatorMessage: "Please enter your email address.",
                ),
                const SizedBox(height: 8.0),
                Text('Contact Number', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                AppInputField(
                  label: '',
                  controller: _contact,
                  required: true,
                  visualDensityY: 0,
                  textSize: 16,
                  validatorMessage: "Please enter your contact number.",
                ),
                const SizedBox(height: 8.0),
                Text('Username', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                AppInputField(
                  label: '',
                  controller: _username,
                  required: true,
                  visualDensityY: 0,
                  textSize: 16,
                  validatorMessage: "Please enter your username.",
                ),
                const SizedBox(height: 8.0),
                Text('Password', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                AppInputField(
                  label: '',
                  controller: _password,
                  required: true,
                  visualDensityY: 0,
                  textSize: 16,
                  obscureText: true,
                  validatorMessage: "Please enter your password.",
                ),
                const SizedBox(height: 8.0),
                Text('I am a:', textAlign: TextAlign.start, style: AppText.textSm),
                const SizedBox(height: 7.0),
                AppSelect<String>(
                  items: roles.map((role) => role['value']!).toList(),
                  placeholder: "Select Role",
                  getLabel: (item) =>
                      roles.firstWhere((role) => role['value'] == item)['label']!,
                  visualDensityY: 1,
                  textSize: 16,
                  borderColor: AppColor.muted,
                  value: _role,
                  onChanged: (value) {
                      setState(() {
                          _role = value;
                      });
                  },
                  required: true,
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
                      onTap: () => {
                        navigateTo(context, const Login())
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