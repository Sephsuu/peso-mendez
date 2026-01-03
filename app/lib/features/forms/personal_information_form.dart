import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/job_reference.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const caviteLocations = ["Alfonso","Amadeo","Bacoor City","Carmona","Cavite City","Cavite Province","City of General Trias","Dasmariñas City","General Emilio Aguinaldo","General Mariano Alvarez","Imus City","Indang","Kawit","Magallanes","Maragondon","Mendez","Naic","Noveleta","Rosario","Silang","Tagaytay City","Tanza","Ternate","Trece Martires City"];

class PersonalInformationForm extends StatefulWidget {
  final int userId;
  final bool fromProfile;

  const PersonalInformationForm({ 
    super.key,
    required this.userId,
    this.fromProfile = false,
  });

  @override 
  State<PersonalInformationForm> createState() => _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<PersonalInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> genders = ['Male', 'Female', 'Others'];
  final List<String> civilStatus = ['Single', 'Married', 'Widowed'];
  final List<String> disabilities = ['N/A', 'Visual', 'Hearing', 'Speech', 'Physical', 'Mental', 'Others'];
  final List<String> employmentStatus = ['Employed', 'Unemployed'];
  final List<String> employedTypes = ['Job Seeker', 'Student', 'Research Planner', 'Migrant Worker', 'Returning OFW', 'OSY'];
  final List<String> unemployedTypes = ['New/Fresh Graduate', 'Finished Contract', 'Resigned', 'Retired', 'Laid off due to calamity', 'Terminated'];
  final clienteleOptions = ["Jobseeker","Student","Researcher/Planner","Migrant Worker","Returning OFW","OSY"];
  final List<String> isOfw = ['Yes', 'No'];
  final List<String> isFormerOfw = ['Yes', 'No'];
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _suffix = TextEditingController();
  final TextEditingController _religion = TextEditingController();
  final TextEditingController _presentAddress = TextEditingController();
  final TextEditingController _citmun = TextEditingController();
  final TextEditingController _civilStatus = TextEditingController();
  final TextEditingController _sex = TextEditingController();
  final TextEditingController _disability = TextEditingController();
  final TextEditingController _clientele = TextEditingController();
  final TextEditingController _tin = TextEditingController();
  String? _selectedSex;
  String? _selectedDisability;
  String? _employmentStatus;
  String? _employmentType;
  String? _isOfw;
  String? _isFormerOfw;
  String? _selectedCivilStatus;
  String? _selectedCitmun;
  String? _selectedClientele;
  DateTime? _selectedDate; 


  @override
  void dispose() {
    _surname.dispose();
    _firstName.dispose();
    _middleName.dispose();
    _suffix.dispose();
    _religion.dispose();
    _presentAddress.dispose();
    _tin.dispose();
    _citmun.dispose();
    super.dispose();
  }

  Future<void> _nextForm() async {
    if (_formKey.currentState!.validate()) {
      if (_tin.text.trim().length < 9 && _tin.text.trim().length > 1) {
        return AppSnackbar.show(
          context, 
          message: "TIN ID must be 9 characters long.",
          backgroundColor: AppColor.danger
        );
      }
      final formattedDate = _selectedDate != null
      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
      : null;
      final Map<String, dynamic> personalInfo = {
        "userId": widget.userId,
        "surname": _surname.text.trim(),
        "firstName": _firstName.text.trim(),
        "middleName": _middleName.text.trim(),
        "suffix": _suffix.text.trim(),
        "religion": _religion.text.trim(),
        "presentAddress": _presentAddress.text.trim(),
        "tin": _tin.text.trim(),
        "sex": _sex.text.trim(),               // FIXED
        "civilStatus": _civilStatus.text.trim(), // FIXED
        "disability": _disability.text.trim(), // FIXED
        "employmentStatus": _employmentStatus,
        "employmentType": _employmentType,
        "isOfw": _isOfw,
        "isFormerOfw": _isFormerOfw,
        "dateOfBirth": formattedDate,
        "citmun": _citmun.text.trim(),
        "clientele": _clientele.text.trim(),
      }; 
      try {
        final res = await UserService.createPersonalInformation(personalInfo);
        if (res.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context,
            message: 'Personal Information updated successfully! You may now proceed to job reference form.',
            backgroundColor: AppColor.success
          );
          widget.fromProfile ? Navigator.pop(context) : navigateTo(context, JobReferenceForm(userId: widget.userId));
        }
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(
          context,
          message: 'Error $e',
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
                          child: Text('Personal Information', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                        ),
                        const SizedBox(height: 20.0),
                        AppInputField(
                          label: 'Last Name',
                          controller: _surname,
                          required: true,
                          visualDensityY: 0,
                          textSize: 16,
                          validatorMessage: "Please enter your last name.",
                        ),
                        const SizedBox(height: 15.0),
                        AppInputField(
                          label: 'First Name',
                          controller: _firstName,
                          required: true,
                          visualDensityY: 0,
                          textSize: 16,
                          validatorMessage: "Please enter your last name.",
                        ),
                        const SizedBox(height: 15.0),
                        AppInputField(
                          label: 'Middle Name',
                          controller: _middleName,
                          visualDensityY: 0,
                          textSize: 16,
                        ),
                        const SizedBox(height: 15.0),
                        AppInputField(
                          label: 'Suffix',
                          controller: _suffix,
                          visualDensityY: 0,
                          textSize: 16,
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect<String>(
                          items: caviteLocations,
                          value: _selectedCitmun,
                          placeholder: "City/Municipality",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (value) {
                            setState(() {
                              _selectedCitmun = value;
                              _citmun.text = value ?? "";
                            });
                          },
                          required: true,
                        ),
                        const SizedBox(height: 15),
                        AppInputField(
                          label: 'Present Address (House No./Barangay/Municipality/Province)',
                          controller: _presentAddress,
                          visualDensityY: 0,
                          textSize: 16,
                          maxLine: 3,
                        ),
                        const SizedBox(height: 15.0),
                        DateTimeFormField(
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                            labelText: 'Date of Birth',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.event_note),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193)),
                            ),
                          ),
                          mode: DateTimeFieldPickerMode.date,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (date) {
                            if (date == null) return 'Please enter a date';
                            return null;
                          },
                          onChanged: (DateTime? value) {
                            setState(() {
                              _selectedDate = value;
                            });
                          },
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect<String>(
                          items: civilStatus,
                          value: _selectedCivilStatus,
                          placeholder: "Civil Status",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (value) {
                            setState(() {
                              _selectedCivilStatus = value;
                              _civilStatus.text = value ?? "";
                            });
                          },
                          required: true,
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect<String>(
                          items: genders,
                          value: _selectedSex,
                          placeholder: "Sex",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (value) {
                            setState(() {
                              _selectedSex = value;
                              _sex.text = value ?? "";
                            });
                          },
                          required: true,
                        ),
                        const SizedBox(height: 15.0),
                        AppInputField(
                          label: 'Religion',
                          controller: _religion,
                          visualDensityY: 0,
                          textSize: 16,
                        ),
                        const SizedBox(height: 15.0),
                        AppInputField(
                          label: 'TIN Number',
                          controller: _tin,
                          visualDensityY: 0,
                          textSize: 16,
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect<String>(
                          items: disabilities,
                          value: _selectedDisability,
                          placeholder: "Disability",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (value) {
                            setState(() {
                              _selectedDisability = value;
                              _disability.text = value ?? "";
                            });
                          },
                          required: true,
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect(
                          items: employmentStatus, 
                          placeholder: "Employment Status",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (String? newValue) {
                            setState(() {
                              _employmentStatus = newValue;
                              _employmentType = null;
                            });
                          },
                          required: true,
                          validatorMessage: "This field is required.",
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect(
                          items: _employmentStatus == "Employed" ? employedTypes : unemployedTypes, 
                          placeholder: "Employment Type",
                          value: _employmentType,
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (String? newValue) {
                            setState(() {
                              _employmentType = newValue;
                            });
                          },
                          required: true,
                          validatorMessage: "This field is required.",
                        ),
                        const SizedBox(height: 15),
                        AppSelect<String>(
                          items: clienteleOptions,
                          value: _selectedClientele,
                          placeholder: "Clientele",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (value) {
                            setState(() {
                              _selectedClientele = value;
                              _clientele.text = value ?? "";
                            });
                          },
                          required: true,
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect<String>(
                          items: const ["Yes", "No"],
                          placeholder: "Are you an OFW?",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (value) {
                            setState(() {
                              _isOfw = value;
                            });
                          },
                          required: true,
                        ),
                        const SizedBox(height: 15.0),
                        AppSelect<String>(
                          items: const ["Yes", "No"],
                          placeholder: "Are you a former OFW?",
                          getLabel: (item) => item,
                          visualDensityY: 1,
                          textSize: 16,
                          borderColor: AppColor.muted,
                          onChanged: (value) {
                            setState(() {
                              _isFormerOfw = value;
                            });
                          },
                          required: true,
                        ),
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

class MaskAsXFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue) {

    // Mask the displayed text with X’s
    String masked = 'X' * newValue.text.length;

    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
      composing: TextRange.empty,
    );
  }
}
