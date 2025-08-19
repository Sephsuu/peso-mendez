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

class LanguageProfeciencyForm extends StatefulWidget {
  final int userId;

  const LanguageProfeciencyForm({ 
    super.key,
    required this.userId,
  });

  @override 
  _LanguageProfeciencyFormState createState() => _LanguageProfeciencyFormState();
}

class _LanguageProfeciencyFormState extends State<LanguageProfeciencyForm> {
  bool isChecked = false; 
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
                          child: Text('Job Reference', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 20.0),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,  
                                     
                          controlAffinity: ListTileControlAffinity.leading, 
                          title: Text("Read"),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
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