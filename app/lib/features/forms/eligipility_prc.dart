import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/features/forms/work_experience.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class EligibilityPRCForm extends StatefulWidget {
  final int userId;

  const EligibilityPRCForm({ 
    super.key,
    required this.userId,
  });

  @override 
  State<EligibilityPRCForm> createState() => _EligibilityPRCFormState();
}

class _EligibilityPRCFormState extends State<EligibilityPRCForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eligible1 = TextEditingController();
  final TextEditingController _dateTaken1 = TextEditingController();
  final TextEditingController _eligible2 = TextEditingController();
  final TextEditingController _dateTaken2 = TextEditingController();

  final TextEditingController _prc1 = TextEditingController();
  final TextEditingController _validUntil1 = TextEditingController();
  final TextEditingController _prc2 = TextEditingController();
  final TextEditingController _validUntil2 = TextEditingController();
  
 

  @override
  void dispose() {

    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> eligibility1 = {
        "userId": widget.userId,
        "eligibility": _eligible1.text.trim(),
        "dateTaken": _dateTaken1.text.trim()
      }; 
      final Map<String, dynamic> eligibility2 = {
        "userId": widget.userId,
        "eligibility": _eligible2.text.trim(),
        "dateTaken": _dateTaken2.text.trim()
      }; 
      final Map<String, dynamic> license1 = {
        "userId": widget.userId,
        "license": _prc1.text.trim(),
        "validUntil": _validUntil1.text.trim()
      }; 
      final Map<String, dynamic> license2 = {
        "userId": widget.userId,
        "license": _prc2.text.trim(),
        "validUntil": _validUntil2.text.trim()
      }; 
      try {
        final eligibilityRes1 = await UserService.createEligibility(eligibility1);
        final eligibilityRes2 = await UserService.createEligibility(eligibility2);
        final prcRes1 = await UserService.createProfessionalLicense(license1);
        final prcRes2 = await UserService.createProfessionalLicense(license2);
        if (eligibilityRes1.isNotEmpty && eligibilityRes2.isNotEmpty && prcRes1.isNotEmpty && prcRes2.isNotEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Eligibility/Professional License updated successfully! You may now proceed to work experience form.'))
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkExperienceForm(userId: widget.userId)),
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
                          child: Text('Eligibility/Professional License', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 20.0),
                        Text('Eligibility', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        Text('Eligibility 1 (if any)', style: AppText.textMd),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _eligible1, placeholder: "(Civil Servicce)"),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(controller: _dateTaken1, placeholder: "Date Taken (YYYY-MM-DD)"),
                        const SizedBox(height: 10.0),
                        Text('Eligibility 2 (if any)', style: AppText.textMd),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _eligible2, placeholder: "(Civil Servicce)"),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(controller: _dateTaken2, placeholder: "Date Taken (YYYY-MM-DD)"),
                        const SizedBox(height: 20),

                        Text('Professional License (PRC)', style: AppText.textLg.merge(AppText.fontSemibold)),
                        const SizedBox(height: 10.0),
                        Text('PRC License 1 (if any)', style: AppText.textMd),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _prc1, placeholder: "PRC License Name"),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(controller: _validUntil1, placeholder: "Valid Until (YYYY-MM-DD)"),
                        const SizedBox(height: 10.0),
                        Text('PRC License 2 (if any)', style: AppText.textMd),
                        const SizedBox(height: 10.0),
                        RegisterTextFieldPlaceholder(controller: _prc2, placeholder: "PRC License Name"),
                        const SizedBox(height: 5.0),
                        RegisterTextFieldPlaceholder(controller: _validUntil2, placeholder: "Valid Unti (YYYY-MM-DD)"),
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