import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class PersonalInformationForm extends StatefulWidget {
  const PersonalInformationForm({ super.key});

  @override 
  _PersonalInformationFormState createState() => _PersonalInformationFormState();
}

class _PersonalInformationFormState extends State<PersonalInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> civilStatus = ['Single', 'Married', 'Widowed'];
  final List<String> disabilities = ['Visual', 'Hearing', 'Speech', 'Physical', 'Mental', 'Others'];
  final List<String> employmentStatus = ['Employed', 'Unemployed'];
  final List<String> employedTypes = ['Wage employed', 'Self-employed'];
  final List<String> unemployedTypes = ['New/Fresh Graduate', 'Finished Contract', 'Resigned', 'Retired', 'Laid off due to calamity', 'Terminated'];
  final List<String> isOfw = ['Yes', 'No'];
  final List<String> isFormerOfw = ['Yes', 'No'];

  final TextEditingController _surname = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _suffix = TextEditingController();
  final TextEditingController _religion = TextEditingController();
  final TextEditingController _presentAddress = TextEditingController();
  final TextEditingController _tin = TextEditingController();
  String? _sex;
  String? _civilStatus;
  String? _disability;
  String? _employmentStatus;
  String? _employmentType;
  String? _isOfw;
  String? _isFormerOfw;

  @override
  void dispose() {
    _surname.dispose();
    _firstName.dispose();
    _middleName.dispose();
    _suffix.dispose();
    _religion.dispose();
    _presentAddress.dispose();
    _tin.dispose();
    super.dispose();
  }

  void _nextForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data'))
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobSeekerDashboard(onNavigate: (page) => globalNavigateTo?.call(page)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                SizedBox(
                  width: double.infinity,
                  child: Text('Personal Information', textAlign: TextAlign.center, style: AppText.textXl.merge(AppText.textPrimary).merge(AppText.fontSemibold)),
                ),
                const SizedBox(height: 20.0),
                RegisterTextFieldPlaceholderRequired(controller: _surname, placeholder: "Surname"),
                const SizedBox(height: 15.0),
                RegisterTextFieldPlaceholderRequired(controller: _firstName, placeholder: "First Name"),
                const SizedBox(height: 15.0),
                RegisterTextFieldPlaceholder(controller: _middleName, placeholder: "Middle Name"),
                const SizedBox(height: 15.0),
                RegisterTextFieldPlaceholder(controller: _suffix, placeholder: "Suffix"),
                const SizedBox(height: 15.0),
                RegisterTextareaFieldPlaceholderRequired(controller: _presentAddress, placeholder: "Present Address (House No./Barangay/Municipality/Province)"),
                const SizedBox(height: 15.0),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                    ),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (date) {
                    if (date == null) return 'Please enter a date';
                    return null;
                  },
                  onDateSelected: (DateTime value) {
                    print('Selected date: $value');
                  },
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Expanded(
                      child: RegisterDrowdownSelectRequired(
                        items: genders,
                        initialValue: _sex,
                        placeholder: 'Sex',
                        onChanged: (value) {
                          setState(() {
                            _sex = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: RegisterDrowdownSelectRequired(
                        items: civilStatus,
                        initialValue: _civilStatus,
                        placeholder: 'Civil Status',
                        onChanged: (value) {
                          setState(() {
                            _civilStatus = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                RegisterTextFieldPlaceholderRequired(controller: _religion, placeholder: "Religion"),
                const SizedBox(height: 15.0),
                RegisterTextFieldPlaceholderRequired(controller: _tin, placeholder: "TIN Number"),
                const SizedBox(height: 15.0),
                RegisterDrowdownSelect(items: disabilities, initialValue: _disability, placeholder: 'Disability', onChanged: (value) { setState(() { _disability = value; }); }),
                const SizedBox(height: 15.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    labelText: 'Employment Status',
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
                    ),
                  ),
                  value: _employmentStatus,
                  items: employmentStatus.map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _employmentStatus = newValue;
                      _employmentType = null;
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Employment Type',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  ),
                  value: _employmentType,
                  items: (_employmentStatus == 'Employed'
                          ? employedTypes
                          : _employmentStatus == 'Unemployed'
                              ? unemployedTypes
                              : [])
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (String? newType) {
                    setState(() {
                      _employmentType = newType;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select employment type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                RegisterDrowdownSelect(items: isOfw, initialValue: _isOfw, placeholder: 'Are you an OFW', onChanged: (value) { setState(() { _isOfw = value; }); }),
                const SizedBox(height: 15.0),
                RegisterDrowdownSelect(items: isFormerOfw, initialValue: _isFormerOfw, placeholder: 'Are you a former OFW', onChanged: (value) { setState(() { _isFormerOfw = value; }); }),
                const SizedBox(height: 20.0),
                RegisterNextButton(registerUser: _nextForm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}