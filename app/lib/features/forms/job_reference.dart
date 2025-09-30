import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/language_profeciency.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';

class JobReferenceForm extends StatefulWidget {
  final int userId;

  const JobReferenceForm({ 
    super.key,
    required this.userId,
  });

  @override 
  State<JobReferenceForm> createState() => _JobReferenceFormState();
}

class _JobReferenceFormState extends State<JobReferenceForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> occupationTypes = ['Part-time', 'Full-time'];
  final List<String> locationTypes = ['Local', 'Overseas'];

  final TextEditingController _occupation1 = TextEditingController();
  final TextEditingController _occupation2 = TextEditingController();
  final TextEditingController _occupation3 = TextEditingController();
  final TextEditingController _location1 = TextEditingController();
  final TextEditingController _location2 = TextEditingController();
  final TextEditingController _location3 = TextEditingController();
  String? _occupationType;
  String? _locationType;

  @override
  void dispose() {
    _occupation1.dispose();
    _occupation2.dispose();
    _occupation3.dispose();
    _location1.dispose();
    _location2.dispose();
    _location3.dispose();
    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> jobRef = {
        "userId": widget.userId,
        "occupationType": _occupationType,
        "occupation1": _occupation1.text.trim(),
        "occupation2": _occupation2.text.trim(),
        "occupation3": _occupation3.text.trim(),
        "locationType": _locationType,
        "location1": _location1.text.trim(),
        "location2": _location2.text.trim(),
        "location3": _location3.text.trim(),
      }; 
      try {
        final res = await UserService.createJobReference(jobRef);
        if (res.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context,
            message: 'Job Reference updated successfully! You may now proceed to language profeciency form.',
            backgroundColor: AppColor.success
          );
          navigateTo(context, LanguageProfeciencyForm(userId: widget.userId));
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
                            child: Text('Skip for now', style: AppText.textPrimary),
                            onTap: () {
                              AppSnackbar.show(
                                context,
                                message: 'You can edit your information on your profile when you logged in.',
                                backgroundColor: AppColor.primary
                              );
                              navigateTo(context, const Login());
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: Text('Job Reference', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 20.0),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            labelText: 'Occupation Type',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                            ),
                          ),
                          value: _occupationType,
                          items: occupationTypes.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _occupationType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0),
                        RegisterTextFieldPlaceholderRequired(controller: _occupation1, placeholder: "Preferred Occupation 1"),
                        const SizedBox(height: 15.0),
                        RegisterTextFieldPlaceholderRequired(controller: _occupation2, placeholder: "Preferred Occupation 2"),
                        const SizedBox(height: 15.0),
                        RegisterTextFieldPlaceholderRequired(controller: _occupation3, placeholder: "Preferred Occupation 3"),
                        const SizedBox(height: 30.0),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            labelText: 'Location Type',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                            ),
                          ),
                          value: _locationType,
                          items: locationTypes.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _locationType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15.0),
                        RegisterTextFieldPlaceholderRequired(controller: _location1, placeholder: "Preferred Work Location 1"),
                        const SizedBox(height: 15.0),
                        RegisterTextFieldPlaceholderRequired(controller: _location2, placeholder: "Preferred Work Location 2"),
                        const SizedBox(height: 15.0),
                        RegisterTextFieldPlaceholderRequired(controller: _location3, placeholder: "Preferred Work Location 3"),
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