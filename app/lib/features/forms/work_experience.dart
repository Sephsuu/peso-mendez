import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class WorkExperienceForm extends StatefulWidget {
  final int userId;

  const WorkExperienceForm({ 
    super.key,
    required this.userId,
  });

  @override 
  State<WorkExperienceForm> createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<WorkExperienceForm> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _workExp1 = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  final List<TextEditingController> _workExp2 = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  final List<TextEditingController> _workExp3 = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

  @override
  void dispose() {

    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> workExp1 = {
        "userId": widget.userId,
        "companyName": _workExp1[0].text.trim(),
        "address": _workExp1[1].text.trim(),
        "position": _workExp1[2].text.trim(),
        "noOfMonth": _workExp1[3].text.trim(),
        "status": _workExp1[4].text.trim(),
      }; 
      final Map<String, dynamic> workExp2 = {
        "userId": widget.userId,
        "companyName": _workExp2[0].text.trim(),
        "address": _workExp2[1].text.trim(),
        "position": _workExp2[2].text.trim(),
        "noOfMonth": _workExp2[3].text.trim(),
        "status": _workExp2[4].text.trim(),
      }; 
      final Map<String, dynamic> workExp3 = {
        "userId": widget.userId,
        "companyName": _workExp3[0].text.trim(),
        "address": _workExp3[1].text.trim(),
        "position": _workExp3[2].text.trim(),
        "noOfMonth": _workExp3[3].text.trim(),
        "status": _workExp3[4].text.trim(),
      }; 

      try {
        final workExpRes1 = await UserService.createWorkExperience(workExp1);
        final workExpRes2 = await UserService.createWorkExperience(workExp2);
        final workExpRes3 = await UserService.createWorkExperience(workExp3);
        if (workExpRes1.isNotEmpty && workExpRes2.isNotEmpty && workExpRes3.isNotEmpty) {
          if (!mounted) return;
          showAlertError(context, 'Created');
        }
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
                            child: Text('Skip for now', style: AppText.textPrimary),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('You can edit your information on your profile when you logged in.')),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login(onNavigate: (page) => globalNavigateTo?.call(page),
                        ),
                      ));
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: Text('Work Experience', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 5.0),
                        const Text('Limit to 10 year period, start with the most recent employment.'),
                        const SizedBox(height: 10.0),
                        Text('Work Experience 1', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp1[0], placeholder: 'Company Name'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp1[1], placeholder: 'Address (City/Municipality)'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp1[2], placeholder: 'Position'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp1[3], placeholder: 'No. of months'),
                        const SizedBox(height: 10.0),
                        const Text('Status'),
                        RegisterTextFieldPlaceholder(controller: _workExp1[4], placeholder: 'e.g. Permanent, Contractual, etc.'),

                        Text('Work Experience 2', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp2[0], placeholder: 'Company Name'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp2[1], placeholder: 'Address (City/Municipality)'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp2[2], placeholder: 'Position'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp2[3], placeholder: 'No. of months'),
                        const SizedBox(height: 10.0),
                        const Text('Status'),
                        RegisterTextFieldPlaceholder(controller: _workExp2[4], placeholder: 'e.g. Permanent, Contractual, etc.'),

                        Text('Work Experience 3', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp3[0], placeholder: 'Company Name'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp3[1], placeholder: 'Address (City/Municipality)'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp3[2], placeholder: 'Position'),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _workExp3[3], placeholder: 'No. of months'),
                        const SizedBox(height: 10.0),
                        const Text('Status'),
                        RegisterTextFieldPlaceholder(controller: _workExp3[4], placeholder: 'e.g. Permanent, Contractual, etc.'),

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