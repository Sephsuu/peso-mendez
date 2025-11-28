import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/eligipility_prc.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';

class TechVocForm extends StatefulWidget {
  final int userId;
  final bool fromProfile; // ✅ Added to match your other forms

  const TechVocForm({
    super.key,
    required this.userId,
    this.fromProfile = false, // ✅ Default value (false)
  });

  @override
  State<TechVocForm> createState() => _TechVocFormState();
}

class _TechVocFormState extends State<TechVocForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _techVocCourse1 = TextEditingController();
  final TextEditingController _techVocCourse2 = TextEditingController();
  final TextEditingController _techVocCourse3 = TextEditingController();

  final TextEditingController _hrsTraining1 = TextEditingController();
  final TextEditingController _hrsTraining2 = TextEditingController();
  final TextEditingController _hrsTraining3 = TextEditingController();

  final TextEditingController _institution1 = TextEditingController();
  final TextEditingController _institution2 = TextEditingController();
  final TextEditingController _institution3 = TextEditingController();

  final TextEditingController _skillsAcquired1 = TextEditingController();
  final TextEditingController _skillsAcquired2 = TextEditingController();
  final TextEditingController _skillsAcquired3 = TextEditingController();

  final TextEditingController _certReceived1 = TextEditingController();
  final TextEditingController _certReceived2 = TextEditingController();
  final TextEditingController _certReceived3 = TextEditingController();

  @override
  void dispose() {
    _techVocCourse1.dispose();
    _techVocCourse2.dispose();
    _techVocCourse3.dispose();
    _hrsTraining1.dispose();
    _hrsTraining2.dispose();
    _hrsTraining3.dispose();
    _institution1.dispose();
    _institution2.dispose();
    _institution3.dispose();
    _skillsAcquired1.dispose();
    _skillsAcquired2.dispose();
    _skillsAcquired3.dispose();
    _certReceived1.dispose();
    _certReceived2.dispose();
    _certReceived3.dispose();
    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> techVoc1 = {
        "userId": widget.userId,
        "course": _techVocCourse1.text.trim(),
        "hoursTraining": _hrsTraining1.text.trim(),
        "institution": _institution1.text.trim(),
        "skillsAcquired": _skillsAcquired1.text.trim(),
        "certReceived": _certReceived1.text.trim(),
      };
      final Map<String, dynamic> techVoc2 = {
        "userId": widget.userId,
        "course": _techVocCourse2.text.trim(),
        "hoursTraining": _hrsTraining2.text.trim(),
        "institution": _institution2.text.trim(),
        "skillsAcquired": _skillsAcquired2.text.trim(),
        "certReceived": _certReceived2.text.trim(),
      };
      final Map<String, dynamic> techVoc3 = {
        "userId": widget.userId,
        "course": _techVocCourse3.text.trim(),
        "hoursTraining": _hrsTraining3.text.trim(),
        "institution": _institution3.text.trim(),
        "skillsAcquired": _skillsAcquired3.text.trim(),
        "certReceived": _certReceived3.text.trim(),
      };

      try {
        final techVocRes1 = await UserService.createTechVocTraining(techVoc1);
        final techVocRes2 = await UserService.createTechVocTraining(techVoc2);
        final techVocRes3 = await UserService.createTechVocTraining(techVoc3);

        if (techVocRes1.isNotEmpty && techVocRes2.isNotEmpty && techVocRes3.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context,
            message:
                'Technical and Vocational updated successfully! You may now proceed to eligibility/professional license form.',
            backgroundColor: AppColor.success,
          );

          // ✅ Conditional navigation: from profile vs registration
          widget.fromProfile
              ? Navigator.pop(context)
              : navigateTo(context, EligibilityPRCForm(userId: widget.userId));
        }
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(
          context,
          message: 'Error $e',
          backgroundColor: AppColor.danger,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) {
          Scaffold.of(context).openDrawer();
        },
      ),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 244, 244, 244),
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 10.0,
                bottom: 30.0,
              ),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 30.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Conditional Back / Skip logic
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            child: Text(
                              widget.fromProfile ? 'Back' : 'Skip for now',
                              style: AppText.textPrimary,
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
                          child: Text(
                            'Technical/Vocational and Other Trainings',
                            textAlign: TextAlign.center,
                            style: AppText.textXl
                                .merge(AppText.textPrimary)
                                .merge(AppText.fontSemibold),
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // ✅ Training 1
                        Text('Training 1', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _techVocCourse1, placeholder: "Technical/Vocational Course"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _hrsTraining1, placeholder: "Hrs. of Training"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _institution1, placeholder: "Training Institution"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _skillsAcquired1, placeholder: "Skills Acquired"),
                        const SizedBox(height: 10.0),
                        const Text('Certificate Received'),
                        RegisterTextFieldPlaceholder(controller: _certReceived1, placeholder: "e.g. NC I, NC II, NC III, etc."),
                        const SizedBox(height: 20.0),

                        // ✅ Training 2
                        Text('Training 2', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _techVocCourse2, placeholder: "Technical/Vocational Course"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _hrsTraining2, placeholder: "Hrs. of Training"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _institution2, placeholder: "Training Institution"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _skillsAcquired2, placeholder: "Skills Acquired"),
                        const SizedBox(height: 10.0),
                        const Text('Certificate Received'),
                        RegisterTextFieldPlaceholder(controller: _certReceived2, placeholder: "e.g. NC I, NC II, NC III, etc."),
                        const SizedBox(height: 20.0),

                        // ✅ Training 3
                        Text('Training 3', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _techVocCourse3, placeholder: "Technical/Vocational Course"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _hrsTraining3, placeholder: "Hrs. of Training"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _institution3, placeholder: "Training Institution"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _skillsAcquired3, placeholder: "Skills Acquired"),
                        const SizedBox(height: 10.0),
                        const Text('Certificate Received'),
                        RegisterTextFieldPlaceholder(controller: _certReceived3, placeholder: "e.g. NC I, NC II, NC III, etc."),
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
