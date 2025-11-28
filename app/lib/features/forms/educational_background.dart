import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/features/forms/techvoc_training.dart';
import 'package:flutter/material.dart';

final List<String> educationLevels = [
  "No grade completed",
  "Elementary Level",
  "Elementary Graduate",
  "Junior High School Level",
  "Junior High School Graduate",
  "Senior High School Level",
  "Senior High School Graduate",
  "High School Level (Non K-12)",
  "High School Graduate (Non K-12)",
  "Alternative Learning System",
  "Vocational Level",
  "College Level",
  "College Graduate",
  "Some Masteral Units",
  "Master's Degree Holder",
  "Some Doctorate Units",
];


class EducationalBackgroundForm extends StatefulWidget {
  final int userId;
  final bool fromProfile;

  const EducationalBackgroundForm({ 
    super.key,
    required this.userId,
    this.fromProfile = false,
  });

  @override 
  State<EducationalBackgroundForm> createState() => _EducationalBackgroundState();
}

class _EducationalBackgroundState extends State<EducationalBackgroundForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _elemYearGrad = TextEditingController();
  final TextEditingController _elemLevelReached = TextEditingController();
  final TextEditingController _elemYearLastAttended = TextEditingController();

  final TextEditingController _secoYearGrad = TextEditingController();
  final TextEditingController _secoLevelReached = TextEditingController();
  final TextEditingController _secoYearLastAttended = TextEditingController();

  final TextEditingController _terCourse = TextEditingController();
  final TextEditingController _terYearGrad = TextEditingController();
  final TextEditingController _terLevelReached = TextEditingController();
  final TextEditingController _terYearLastAttended = TextEditingController();

  final TextEditingController _gsCourse = TextEditingController();
  final TextEditingController _gsrYearGrad = TextEditingController();
  final TextEditingController _gsrLevelReached = TextEditingController();
  final TextEditingController _gsrYearLastAttended = TextEditingController();

  final TextEditingController _shsStrand = TextEditingController();

  bool isKto12 = false;
  String? _highestEducation;

  @override
  void dispose() {

    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> educBg = {
        "userId": widget.userId,

        "elemYearGrad": _elemYearGrad.text.trim(),
        "elemLevelReached": _elemLevelReached.text.trim(),
        "elemYearLastAttended": _elemYearLastAttended.text.trim(),

        "secoYearGrad": _secoYearGrad.text.trim(),
        "secoLevelReached": _secoLevelReached.text.trim(),
        "secoYearLastAttended": _secoYearLastAttended.text.trim(),

        "terCourse": _terCourse.text.trim(),
        "terYearGrad": _terYearGrad.text.trim(),
        "terLevelReached": _terLevelReached.text.trim(),
        "terYearLastAttended": _terYearLastAttended.text.trim(),

        "gsCourse": _gsCourse.text.trim(),
        "gsYearGrad": _gsrYearGrad.text.trim(),
        "gsLevelReached": _gsrLevelReached.text.trim(),
        "gsYearLastAttended": _gsrYearLastAttended.text.trim(),

        "isKto12": isKto12,
        "shsStrand": _shsStrand.text.trim(),
        "highest_education": _highestEducation ?? "",
      };
      try {
        final res = await UserService.createEducationalBackground(educBg);
        if (res.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Educational Background updated successfully! You may now proceed to tech-voc training form.',
            backgroundColor: AppColor.success
          );
          widget.fromProfile
              ? Navigator.pop(context)
              : navigateTo(context, TechVocForm(userId: widget.userId));
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
                            child: Text(widget.fromProfile ? 'Back' : 'Skip for now', style: AppText.textPrimary),
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
                          child: Text('Educational Background', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 20.0),
                        AppSelect<String>(
                          items: educationLevels,
                          value: _highestEducation,
                          placeholder: "Highest Educational Attainment",
                          getLabel: (item) => item,
                          onChanged: (value) {
                            setState(() {
                              _highestEducation = value;
                            });
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Text('Elementary', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(
                          controller: _elemYearGrad,
                          placeholder: 'Year Graduated',
                        ),
                        const SizedBox(height: 10.0),
                        const Align(
                          alignment: Alignment.center,
                          child: Text('If undergraduate:'),
                        ),
                        RegisterTextFieldPlaceholder(
                          controller: _elemLevelReached, 
                          placeholder: 'Level Reached',
                        ),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(
                          controller: _elemYearLastAttended, 
                          placeholder: 'Year Last Attended',
                        ),
                        const SizedBox(height: 20.0),
                        Text('Secondary', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 5.0),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: RadioListTile<bool>(
                                    title: Text("K-12", style: AppText.textXs),
                                    value: true,
                                    groupValue: isKto12,
                                    onChanged: (value) {
                                      setState(() {
                                        isKto12 = value!;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile<bool>(
                                    title: Text("Non-K12", style: AppText.textXs),
                                    value: false,
                                    groupValue: isKto12,
                                    onChanged: (value) {
                                      setState(() {
                                        isKto12 = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Text('If K-12'),
                        RegisterTextFieldPlaceholder(
                          controller: _shsStrand,
                          placeholder: 'Senior High Strand',
                          enabled: isKto12,
                        ),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(
                          controller: _secoYearGrad,
                          placeholder: 'Year Graduated',
                        ),
                        const SizedBox(height: 10.0),
                        const Align(
                          alignment: Alignment.center,
                          child: Text('If undergraduate:'),
                        ),
                        RegisterTextFieldPlaceholder(
                          controller: _secoLevelReached, 
                          placeholder: 'Level Reached',
                        ),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(
                          controller: _secoYearLastAttended, 
                          placeholder: 'Year Last Attended',
                        ),
                        const SizedBox(height: 20.0),
                        Text('Tertiary', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(
                          controller: _terCourse,
                          placeholder: 'Course',
                        ),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(
                          controller: _terYearGrad,
                          placeholder: 'Year Graduated',
                        ),
                        const SizedBox(height: 10.0),
                        const Align(
                          alignment: Alignment.center,
                          child: Text('If undergraduate:'),
                        ),
                        RegisterTextFieldPlaceholder(
                          controller: _terLevelReached, 
                          placeholder: 'Level Reached',
                        ),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(
                          controller: _terYearLastAttended, 
                          placeholder: 'Year Last Attended',
                        ),
                        const SizedBox(height: 20.0),
                        Text('Graduate Studies/Post Graduate', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(
                          controller: _gsCourse,
                          placeholder: 'Course',
                        ),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(
                          controller: _gsrYearGrad,
                          placeholder: 'Year Graduated',
                        ),
                        const SizedBox(height: 10.0),
                        const Align(
                          alignment: Alignment.center,
                          child: Text('If undergraduate:'),
                        ),
                        RegisterTextFieldPlaceholder(
                          controller: _gsrLevelReached, 
                          placeholder: 'Level Reached',
                        ),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(
                          controller: _gsrYearLastAttended, 
                          placeholder: 'Year Last Attended',
                        ),
                        const SizedBox(height: 15),
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