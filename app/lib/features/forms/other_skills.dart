import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/checkbox.dart';

import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';

class OtherSkillsForm extends StatefulWidget {
  final int userId;
  final bool fromProfile;

  const OtherSkillsForm({ 
    super.key,
    required this.userId,
    this.fromProfile = false,
  });

  @override 
  State<OtherSkillsForm> createState() => _OtherSkillsFormState();
}

class _OtherSkillsFormState extends State<OtherSkillsForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> skills = [
    'Auto Mechnanic', 'Beautician', 'Carpentry Work',  'Computer Literate', 'Domestic Chores', 'Driver',
    'Electrician', 'Embroidery', 'Gardening', 'Masonry', 'Painter/Artist', 'Painting Jobs',
    'Photography', 'Plumbing', 'Sewing Dresses', 'Stenography', 'Tailoring'
  ];

  List<String> selectedSkills = [];

  @override
  void dispose() {

    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        for (var item in selectedSkills) {
          await UserService.createOtherSkill({
            "userId": widget.userId,
            "skill": item
          });
        }
        if (!mounted) return;
        widget.fromProfile ? Navigator.pop(context) : navigateTo(context, const Login());
      } catch (e) {
        if (!mounted) return;
        showAlertError(context, 'Error: $e');
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
              padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
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
                              AppSnackbar.show(
                                context,
                                message: 'You can edit your information on your profile when you logged in.',
                                backgroundColor: AppColor.primary
                              );
                              widget.fromProfile ? Navigator.pop(context) : navigateTo(context, const Login());
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: Text('Other Skills Without Certificate', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 5.0),
                        const Text('Select skills that are matched to yours.'),
                        const SizedBox(height: 20.0),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 20,
                          shrinkWrap: true,
                          childAspectRatio: 3,
                          children: skills.map((item) {
                            final isChecked = selectedSkills.contains(item);
                            return AppCheckbox(
                              label: item, 
                              state: isChecked, 
                              textStyle: AppText.textXs,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedSkills.add(item);
                                  } else {
                                    selectedSkills.remove(item);
                                  }
                                });
                              });
                          }).toList(),
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