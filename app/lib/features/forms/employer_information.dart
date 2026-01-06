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
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const caviteLocations = [
  "Alfonso","Amadeo","Bacoor City","Carmona","Cavite City","Cavite Province",
  "City of General Trias","Dasmariñas City","General Emilio Aguinaldo",
  "General Mariano Alvarez","Imus City","Indang","Kawit","Magallanes",
  "Maragondon","Mendez","Naic","Noveleta","Rosario","Silang","Tagaytay City",
  "Tanza","Ternate","Trece Martires City"
];

final employerTypes = [
  "Local - Private (Wage)",
  "Local - Government (Wage)",
  "Overseas (Wage)",
  "Not Applicable"
];

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

class EmployerInformationForm extends StatefulWidget {
  final int employerId;

  const EmployerInformationForm({
    super.key,
    required this.employerId,
  });

  @override
  State<EmployerInformationForm> createState() =>
      _EmployerInformationFormState();
}

class _EmployerInformationFormState extends State<EmployerInformationForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String> sexOptions = [
    'Male',
    'Female',
    'Prefer not to say'
  ];

  final TextEditingController _surname = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _citmun = TextEditingController();
  final TextEditingController _company_name = TextEditingController();
  final TextEditingController _company_address = TextEditingController();
  final TextEditingController _company_contact = TextEditingController();

  // NO LONGER A TEXT FIELD — NOW a dropdown
  String? _selectedEducation;

  String? _selectedSex;
  String? _selectedEmployerType;
  String? _selectedCitmun;

  DateTime? _selectedDate;

  @override
  void dispose() {
    _surname.dispose();
    _firstName.dispose();
    _middleName.dispose();
    _citmun.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final formattedDate = _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : null;

      final payload = {
        "employer_id": widget.employerId,
        "surname": _surname.text.trim(),
        "first_name": _firstName.text.trim(),
        "middle_name": _middleName.text.trim(),
        "date_of_birth": formattedDate,
        "sex": _selectedSex,
        "citmun": _citmun.text.trim(),
        "highest_education": _selectedEducation, // NOW SELECT VALUE
        "employer_type": _selectedEmployerType,
        "company_name": _company_name.text.trim(),
        "company_address": _company_address.text.trim(),
        "company_contact": _company_contact.text.trim(),
      };

      try {
        final res = await UserService.createEmployerInformation(payload);
        if (res.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context,
            message: "Employer information saved successfully!",
            backgroundColor: AppColor.success,
          );
          navigateTo(context, const Login());
        }
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(
          context,
          message: "Error: $e",
          backgroundColor: AppColor.danger,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(
        title: "Employer Information",
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),

      body: SingleChildScrollView(
        child: Container(
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
                    
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Employer Information",
                        textAlign: TextAlign.center,
                        style: AppText.textXl
                            .merge(AppText.textPrimary)
                            .merge(AppText.fontSemibold),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text('Company Information', style: AppText.fontSemibold.merge(AppText.textLg)),
                    const SizedBox(height: 15),

                    AppInputField(
                      label: "Company Name",
                      controller: _company_name,
                      visualDensityY: 0,
                      validator: (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 15),

                    AppInputField(
                      label: "Company Address",
                      controller: _company_address,
                      visualDensityY: 0,
                      validator: (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 15),

                    AppInputField(
                      label: "Company Contact",
                      controller: _company_contact,
                      visualDensityY: 0,
                      validator: (v) => v == null || v.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: 20),

                    Text('Company Representative (optional)', style: AppText.fontSemibold.merge(AppText.textLg)),
                    const SizedBox(height: 15),

                    AppInputField(
                      label: "Surname",
                      controller: _surname,
                      visualDensityY: 0,
                    ),
                    const SizedBox(height: 15),

                    AppInputField(
                      label: "First Name",
                      controller: _firstName,
                      visualDensityY: 0,
                    ),
                    const SizedBox(height: 15),

                    AppInputField(
                      label: "Middle Name",
                      controller: _middleName,
                      visualDensityY: 0,
                    ),
                    const SizedBox(height: 15),

                    DateTimeFormField(
                      decoration: const InputDecoration(
                        labelText: "Date of Birth",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event),
                        isDense: true,
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      onChanged: (val) => _selectedDate = val,
                    ),
                    const SizedBox(height: 15),

                    AppSelect<String>(
                      items: sexOptions,
                      value: _selectedSex,
                      placeholder: "Sex",
                      getLabel: (item) => item,
                      visualDensityY: 1,
                      onChanged: (v) => setState(() => _selectedSex = v),
                    ),
                    const SizedBox(height: 15),

                    AppSelect<String>(
                      items: caviteLocations,
                      value: _selectedCitmun,
                      placeholder: "City / Municipality",
                      getLabel: (item) => item,
                      visualDensityY: 1,
                      onChanged: (v) {
                        setState(() {
                          _selectedCitmun = v;
                          _citmun.text = v ?? "";
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    // 🔥 NEW — EDUCATIONAL ATTAINMENT SELECT
                    AppSelect<String>(
                      items: educationLevels,
                      value: _selectedEducation,
                      placeholder: "Highest Educational Attainment",
                      getLabel: (item) => item,
                      visualDensityY: 1,
                      onChanged: (v) => setState(() => _selectedEducation = v),
                    ),
                    const SizedBox(height: 15),

                    AppSelect<String>(
                      items: employerTypes,
                      value: _selectedEmployerType,
                      placeholder: "Type of Employer",
                      visualDensityY: 1,
                      getLabel: (item) => item,
                      onChanged: (v) => setState(() => _selectedEmployerType = v),
                    ),
                    const SizedBox(height: 30),

                    AppButton(
                      label: "Submit",
                      onPressed: _submit,
                      visualDensityY: -2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
