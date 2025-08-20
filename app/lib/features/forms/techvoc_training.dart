import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/eligipility_prc.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class TechVocForm extends StatefulWidget {
  final int userId;

  const TechVocForm({ 
    super.key,
    required this.userId,
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Technical and Vocational updated successfully! You may now proceed to eligibility/professional license form.'))
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EligibilityPRCForm(userId: widget.userId)),
          );
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
                          child: Text('Technical/Vocational and Other Trainings', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 20.0),
                        Text('Traning 1', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _techVocCourse1, placeholder: "Technical/Vocational Cource"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _hrsTraining1, placeholder: "Hrs. of Training"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _institution1, placeholder: "Training Institution"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _skillsAcquired1, placeholder: "Skills Acquired"),
                        const SizedBox(height: 10.0),
                        const Text('Certificate Received'),
                        RegisterTextFieldPlaceholderRequired(controller: _certReceived1, placeholder: "e.g. NC I, NC II, NC III, etc."),
                        const SizedBox(height: 10.0),
                        const SizedBox(height: 15.0),

                        Text('Traning 2', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _techVocCourse2, placeholder: "Technical/Vocational Cource"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _hrsTraining2, placeholder: "Hrs. of Training"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _institution2, placeholder: "Training Institution"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _skillsAcquired2, placeholder: "Skills Acquired"),
                        const SizedBox(height: 10.0),
                        const Text('Certificate Received'),
                        RegisterTextFieldPlaceholderRequired(controller: _certReceived2, placeholder: "e.g. NC I, NC II, NC III, etc."),
                        const SizedBox(height: 10.0),
                        const SizedBox(height: 15.0),

                        Text('Traning 3', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _techVocCourse3, placeholder: "Technical/Vocational Cource"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _hrsTraining3, placeholder: "Hrs. of Training"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _institution3, placeholder: "Training Institution"),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholderRequired(controller: _skillsAcquired3, placeholder: "Skills Acquired"),
                        const SizedBox(height: 10.0),
                        const Text('Certificate Received'),
                        RegisterTextFieldPlaceholderRequired(controller: _certReceived3, placeholder: "e.g. NC I, NC II, NC III, etc."),
                        const SizedBox(height: 15.0),

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