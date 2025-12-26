import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/personal_information_form.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const caviteLocations = ["Alfonso","Amadeo","Bacoor City","Carmona","Cavite City","Cavite Province","City of General Trias","Dasmariñas City","General Emilio Aguinaldo","General Mariano Alvarez","Imus City","Indang","Kawit","Magallanes","Maragondon","Mendez","Naic","Noveleta","Rosario","Silang","Tagaytay City","Tanza","Ternate","Trece Martires City"];

class PersonalInformation extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const PersonalInformation({
    super.key,
    required this.claims,
    required this.open,
    required this.setOpen,
  });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final user = useState<Map<String, dynamic>>({});

    void handleSubmit() async {
      try {
        final res = await UserService.updateUserPersonalInformation({
          'userId': user.value['user_id'],
          'surname': user.value['surname'],
          'firstName': user.value['first_name'],
          'middleName': user.value['middle_name'],
          'suffix': user.value['suffix'],
          'dateOfBirth': user.value['date_of_birth'],
          'religion': user.value['religion'],
          "citmun": user.value['citmun'],
          'presentAddress': user.value['present_address'],
          'tin': user.value['tin'],
          'sex': user.value['sex'],
          'civilStatus': user.value['civil_status'],
          'disability': user.value['disability'],
          'employmentStatus': user.value['employment_status'],
          'employmentType': user.value['employment_type'],
          'isOfw': user.value['is_ofw'],
          'isFormerOfw': user.value['is_former_ofw'],
        });
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Credential updated successfully!',
            backgroundColor: AppColor.success
          );
        }
      } catch (e) { 
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: '$e',
          backgroundColor: AppColor.danger
        );
      }
    }

    useEffect(() {
      if (claims['id'] == null) return null;
      void fetchData() async {
        try {
          final data = await UserService.getUserPersonalInformation(claims['id']);
          user.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
      return null;
    }, [claims['id']]);

    if (loading.value) return const Loader();

    if (user.value.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'No personal information found.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (claims["role"] == "job_seeker")
                const Text(
                  'Please fill out your personal information to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              const SizedBox(height: 24),
              if (claims["role"] == "job_seeker")
                AppButton(
                  label: 'Fill Out Information',
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.light,
                  onPressed: () => navigateTo(context, PersonalInformationForm(userId: claims['id'], fromProfile: true)), // opens modal form
                ),
            ],
          ),
        ),
      );
    }

    useEffect(() {
      if (open) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AppModal(
              title: 'Edit Personal Information',
              titleStyle: AppText.fontBold.merge(AppText.textXl),
              confirmBackground: AppColor.success,
              confirmForeground: AppColor.light,
              onConfirm: () => handleSubmit(),
              message: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      AppInputField(
                        label: 'First Name',
                        initialValue: user.value['first_name'],
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (value) {
                          user.value = {
                            ...user.value,
                            'first_name': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Middle Name',
                        initialValue: user.value['middle_name'],
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (value) {
                          user.value = {
                            ...user.value,
                            'middle_name': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Surname',
                        initialValue: user.value['surname'],
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (value) {
                          user.value = {
                            ...user.value,
                            'surname': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Suffix',
                        initialValue: user.value['suffix'],
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (value) {
                          user.value = {
                            ...user.value,
                            'suffix': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
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
                        initialValue: user.value['date_of_birth'] != null
                            ? DateTime.tryParse(user.value['date_of_birth'].toString())
                            : null,
                        onChanged: (DateTime? value) {
                          user.value = {
                            ...user.value,
                            'date_of_birth': value?.toIso8601String(), // store in standard format
                          };
                        },
                      ),

                      const SizedBox(height: 12),
                      AppSelect(
                        placeholder: 'Gender',
                        items: const ['Male', 'Female', 'Other'],
                        value: user.value['sex'], 
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (val) => {
                          user.value = {
                            ...user.value,
                            'sex': val
                          }
                        }
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Religion',
                        initialValue: user.value['religion'],
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (value) {
                          user.value = {
                            ...user.value,
                            'religion': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppSelect(
                        placeholder: 'City/Municipality',
                        items: caviteLocations,
                        value: user.value['citmun'], 
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (val) => {
                          user.value = {
                            ...user.value,
                            'citmun': val
                          }
                        }
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Present Address',
                        initialValue: user.value['present_address'],
                        textSize: 16,
                        maxLine: 3,
                        onChanged: (value) {
                          user.value = {
                            ...user.value,
                            'present_address': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'TIN ID',
                        initialValue: user.value['tin'],
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (value) {
                          user.value = {
                            ...user.value,
                            'tin': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppSelect(
                        placeholder: 'Civil Status',
                        items: const ['Single', 'Married', 'Widowed'],
                        value: user.value['civil_status'], 
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (val) => {
                          user.value = {
                            ...user.value,
                            'civil_status': val
                          }
                        }
                      ),
                      const SizedBox(height: 12),
                      AppSelect(
                        placeholder: 'Disablity',
                        items: const ['N/A', 'Visual', 'Hearing', 'Speech', 'Physical', 'Mental', 'Others'],
                        value: user.value['disability'], 
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (val) => {
                          user.value = {
                            ...user.value,
                            'disability': val
                          }
                        }
                      ),
                      const SizedBox(height: 12),
                      AppSelect<String>(
                        placeholder: 'Employment Status',
                        items: const ['Employed', 'Unemployed'],
                        value: user.value['employment_status'] as String?, 
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (val) {
                          user.value = {
                            ...user.value,
                            'employment_status': val
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppSelect<String>(
                        placeholder: 'Employment Type',
                        visualDensityY: 0,
                        textSize: 16,
                        items: user.value['employment_status'] == 'Employed'
                            ? ['Wage employed', 'Self-employed']
                            : [
                                'New/Fresh Graduate',
                                'Finished Contract',
                                'Resigned',
                                'Retired',
                                'Laid off due to calamity',
                                'Terminated'
                              ],
                        value: user.value['employment_type'] as String?,
                        onChanged: (val) {
                          user.value = {
                            ...user.value,
                            'employment_type': val,
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppSelect(
                        placeholder: 'Are you an OFW?',
                        visualDensityY: 0,
                        textSize: 16,
                        items: const ['Yes', 'No'],
                        value: user.value['is_ofw'], 
                        onChanged: (val) => {
                          user.value = {
                            ...user.value,
                            'is_ofw': val
                          }
                        }
                      ),
                      const SizedBox(height: 12),
                      AppSelect(
                        placeholder: 'Are you a former OFW?',
                        items: const ['Yes', 'No'],
                        value: user.value['is_former_ofw'], 
                        visualDensityY: 0,
                        textSize: 16,
                        onChanged: (val) => {
                          user.value = {
                            ...user.value,
                            'is_former_ofw': val
                          }
                        }
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              )
            ),
          ).then((_) => setOpen()); // close after dialog dismissed
        });
      }
      return null;
    }, [open]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          width: double.infinity,  // full width
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight,  
              colors: [
                Color.fromARGB(255, 32, 64, 192),            
                Color.fromARGB(255, 104, 129, 255),             
              ],
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${user.value['surname']} '
                  '${user.value['first_name']} '
                  '${user.value['middle_name'] != null && user.value['middle_name'].isNotEmpty 
                      ? '${user.value['middle_name'][0]}.' 
                      : ''}',
                  style: AppText.textXl.merge(AppText.fontBold).merge(AppText.textLight)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.date_range, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Text((formatDateTime(user.value['date_of_birth'])).toString(), style: AppText.textLight.merge(AppText.fontSemibold))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.transgender, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Text(user.value['sex'], style: AppText.textLight.merge(AppText.fontSemibold))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (claims["role"] != "employer") // 👈 Hide if role == "employer"
                    AppButton(
                      label: 'Edit',
                      onPressed: () => setOpen(),
                      backgroundColor: AppColor.light,
                      foregroundColor: AppColor.dark,
                      visualDensityY: -4,
                    ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Religion:', style: AppText.fontBold),
              Text(user.value['religion']),
              const SizedBox(height: 5),
              Text('City/Municipality:', style: AppText.fontBold),
              Text(user.value['citmun']),
              const SizedBox(height: 5),
              Text('Present Address:', style: AppText.fontBold),
              Text(user.value['present_address']),
              const SizedBox(height: 5),
              Text('TIN No.:', style: AppText.fontBold),
              Text(user.value['tin']),
              const SizedBox(height: 5),
              Text('Civil Status:', style: AppText.fontBold),
              Text(user.value['civil_status']),
              const SizedBox(height: 5),
              Text('Disability:', style: AppText.fontBold),
              Text((user.value['disability'] ?? 'N/A').toString()),
              const SizedBox(height: 5),
              Text('Employment Status:', style: AppText.fontBold),
              Text(user.value['employment_status']),
              const SizedBox(height: 5),
              Text('Employment Type:', style: AppText.fontBold),
              Text(user.value['employment_type']),
              const SizedBox(height: 5),
              Text('An Overseas Filipino Worker (OFW):', style: AppText.fontBold),
              Text(user.value['is_ofw']),
              const SizedBox(height: 5),
              Text('A former Overseas Filipino Workder:', style: AppText.fontBold),
              Text(user.value['is_former_ofw']),
              const SizedBox(height: 5),
              Text('Fill up date:', style: AppText.fontBold),
              Text(formatDateTime(user.value['created_at'])),
              const SizedBox(height: 5),
              Text('Last update:', style: AppText.fontBold),
              Text(formatDateTime(user.value['updated_at'])),
              const SizedBox(height: 20),
            ],
          ),
        )
    

      ],
    );
  }
}
