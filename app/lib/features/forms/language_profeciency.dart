import 'package:app/core/components/button.dart';
import 'package:app/core/components/checkbox.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/educational_background.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';

class LanguageProfeciencyForm extends StatefulWidget {
  final int userId;
  final bool fromProfile;

  const LanguageProfeciencyForm({ 
    super.key,
    required this.userId,
    this.fromProfile = false, // ✅ default value
  });

  @override 
  State<LanguageProfeciencyForm> createState() => _LanguageProfeciencyFormState();
}

class _LanguageProfeciencyFormState extends State<LanguageProfeciencyForm> {
  final _formKey = GlobalKey<FormState>();

  Map<String, bool> englishProfeciency = {
    "Read": false, 
    "Write": false, 
    "Speak": false, 
    "Understand": false
  };

  Map<String, bool> filipinoProfeciency = {
    "Read": false, 
    "Write": false, 
    "Speak": false, 
    "Understand": false
  };

  Map<String, bool> mandarinProfeciency = {
    "Read": false, 
    "Write": false, 
    "Speak": false, 
    "Understand": false
  };

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> englishProf = {
        "userId": widget.userId,
        "language": "English",
        "read": englishProfeciency["Read"],
        "write": englishProfeciency["Write"],
        "speak": englishProfeciency["Speak"],
        "understand": englishProfeciency["Understand"],
      }; 
      final Map<String, dynamic> filipinoProf = {
        "userId": widget.userId,
        "language": "Filipino",
        "read": filipinoProfeciency["Read"],
        "write": filipinoProfeciency["Write"],
        "speak": filipinoProfeciency["Speak"],
        "understand": filipinoProfeciency["Understand"],
      }; 
      final Map<String, dynamic> mandarinProf = {
        "userId": widget.userId,
        "language": "Mandarin",
        "read": mandarinProfeciency["Read"],
        "write": mandarinProfeciency["Write"],
        "speak": mandarinProfeciency["Speak"],
        "understand": mandarinProfeciency["Understand"],
      }; 
      try {
        final englishRes = await UserService.createLanguageProfeciency(englishProf);
        final filipinoRes = await UserService.createLanguageProfeciency(filipinoProf);
        final mandarinRes = await UserService.createLanguageProfeciency(mandarinProf);
        if (englishRes.isNotEmpty && filipinoRes.isNotEmpty && mandarinRes.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Language Profeciency updated successfully! You may now proceed to educational background form.',
            backgroundColor: AppColor.success
          );
          widget.fromProfile
              ? Navigator.pop(context)
              : navigateTo(context, EducationalBackgroundForm(userId: widget.userId));
        }
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(
          context, 
          message: '$e',
          backgroundColor: AppColor.danger
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                        Align(
                          alignment: Alignment.centerRight,  
                          child: GestureDetector(
                            child: Text(
                              widget.fromProfile ? 'Back' : 'Skip for now', 
                              style: AppText.textPrimary
                            ),
                            onTap: () {
                              if (widget.fromProfile) {
                                Navigator.pop(context);
                              } else {
                                AppSnackbar.show(
                                  context,
                                  message:
                                      'You can edit your information on your profile when you logged in.',
                                  backgroundColor: AppColor.primary,
                                );
                                navigateTo(context, const Login());
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: Text('Language Profeciency', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 20.0),
                        Text('English Language', style: AppText.textLg.merge(AppText.fontSemibold)),
                        ...englishProfeciency.entries.map((entry) {
                          return AppCheckbox(
                            label: entry.key, 
                            state: entry.value,
                            onChanged: (bool? newValue) {
                              setState(() {
                                englishProfeciency[entry.key] = newValue ?? false; 
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 20.0),
                        Text('Filipino Language', style: AppText.textLg.merge(AppText.fontSemibold)),
                        ...filipinoProfeciency.entries.map((entry) {
                          return AppCheckbox(
                            label: entry.key, 
                            state: entry.value,
                            onChanged: (bool? newValue) {
                              setState(() {
                                filipinoProfeciency[entry.key] = newValue ?? false; 
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 20.0),
                        Text('Mandarin Language', style: AppText.textLg.merge(AppText.fontSemibold)),
                        ...mandarinProfeciency.entries.map((entry) {
                          return AppCheckbox(
                            label: entry.key, 
                            state: entry.value,
                            onChanged: (bool? newValue) {
                              setState(() {
                                mandarinProfeciency[entry.key] = newValue ?? false; 
                              });
                            },
                          );
                        }),
                        const SizedBox(height: 20.0),
                
                        RegisterNextButton(registerUser: _nextForm),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}