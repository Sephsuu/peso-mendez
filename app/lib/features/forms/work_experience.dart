import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/features/forms/other_skills.dart';
import 'package:flutter/material.dart';

class WorkExperienceForm extends StatefulWidget {
  final int userId;
  final bool fromProfile; // ✅ Added this to maintain consistency

  const WorkExperienceForm({
    super.key,
    required this.userId,
    this.fromProfile = false, // ✅ Default = false
  });

  @override
  State<WorkExperienceForm> createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<WorkExperienceForm> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _workExp1 =
      List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> _workExp2 =
      List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> _workExp3 =
      List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in [
      ..._workExp1,
      ..._workExp2,
      ..._workExp3,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      final workExp1 = {
        "userId": widget.userId,
        "companyName": _workExp1[0].text.trim(),
        "address": _workExp1[1].text.trim(),
        "position": _workExp1[2].text.trim(),
        "noOfMonth": _workExp1[3].text.trim(),
        "status": _workExp1[4].text.trim(),
      };
      final workExp2 = {
        "userId": widget.userId,
        "companyName": _workExp2[0].text.trim(),
        "address": _workExp2[1].text.trim(),
        "position": _workExp2[2].text.trim(),
        "noOfMonth": _workExp2[3].text.trim(),
        "status": _workExp2[4].text.trim(),
      };
      final workExp3 = {
        "userId": widget.userId,
        "companyName": _workExp3[0].text.trim(),
        "address": _workExp3[1].text.trim(),
        "position": _workExp3[2].text.trim(),
        "noOfMonth": _workExp3[3].text.trim(),
        "status": _workExp3[4].text.trim(),
      };

      try {
        final res1 = await UserService.createWorkExperience(workExp1);
        final res2 = await UserService.createWorkExperience(workExp2);
        final res3 = await UserService.createWorkExperience(workExp3);

        if (res1.isNotEmpty && res2.isNotEmpty && res3.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context,
            message:
                'Work experience updated successfully! You may now proceed to other skills without certificate form.',
            backgroundColor: AppColor.success,
          );

          // ✅ Conditional navigation
          widget.fromProfile
              ? Navigator.pop(context)
              : navigateTo(context, OtherSkillsForm(userId: widget.userId));
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
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
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
                        // ✅ Skip/Back logic
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
                            'Work Experience',
                            textAlign: TextAlign.center,
                            style: AppText.textXl
                                .merge(AppText.textPrimary)
                                .merge(AppText.fontSemibold),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        const Text(
                            'Limit to 10-year period, start with the most recent employment.'),
                        const SizedBox(height: 10.0),

                        // ✅ Work Experience 1
                        _buildWorkExpSection("Work Experience 1", _workExp1),
                        const SizedBox(height: 20.0),

                        // ✅ Work Experience 2
                        _buildWorkExpSection("Work Experience 2", _workExp2),
                        const SizedBox(height: 20.0),

                        // ✅ Work Experience 3
                        _buildWorkExpSection("Work Experience 3", _workExp3),
                        const SizedBox(height: 15),

                        RegisterNextButton(registerUser: _nextForm),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper method to reduce repetition
  Widget _buildWorkExpSection(String title, List<TextEditingController> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.textLg.merge(AppText.fontSemibold)),
        const SizedBox(height: 10.0),
        RegisterTextFieldPlaceholder(controller: fields[0], placeholder: 'Company Name'),
        const SizedBox(height: 10.0),
        RegisterTextFieldPlaceholder(controller: fields[1], placeholder: 'Address (City/Municipality)'),
        const SizedBox(height: 10.0),
        RegisterTextFieldPlaceholder(controller: fields[2], placeholder: 'Position'),
        const SizedBox(height: 10.0),
        RegisterTextFieldPlaceholder(controller: fields[3], placeholder: 'No. of months'),
        const SizedBox(height: 10.0),
        const Text('Status'),
        RegisterTextFieldPlaceholder(controller: fields[4], placeholder: 'e.g. Permanent, Contractual, etc.'),
      ],
    );
  }
}
