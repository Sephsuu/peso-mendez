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
import 'package:app/features/forms/educational_background.dart';
import 'package:app/features/job_seeker/profile/job_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EducationalBackround extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const EducationalBackround({
    super.key,
    required this.claims,
    required this.open,
    required this.setOpen,
  });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final user = useState<Map<String, dynamic>>({});
    final tempUser = useState<Map<String, dynamic>>({});

    void handleSubmit() async {
      try {
        final res = await UserService.updateUserEducationalBackground(user.value);
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
          final data = await UserService.getUserEducationalBackground(claims['id']);
          user.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
      return null;
    }, [claims['id']]);

    if (loading.value) return const Loader();

    useEffect(() {
      if (open) {
        // Clone user for editing
        tempUser.value = Map<String, dynamic>.from(user.value);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AppModal(
              title: 'Edit Educational Background',
              titleStyle: AppText.fontBold.merge(AppText.textXl),
              confirmBackground: AppColor.primary,
              confirmForeground: AppColor.light,
              onConfirm: () {
                user.value = tempUser.value;   // apply updates
                handleSubmit();                // save to DB
              },
              message: StatefulBuilder(
                builder: (context, modalSetState) {
                  return SizedBox(
                    height: 420,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          AppSelect<String>(
                            placeholder: 'Highest Educational Attainment',
                            required: true,
                            items: educationLevels,
                            value: safeValue(tempUser.value['highest_education'], educationLevels),
                            getLabel: (v) => v,
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'highest_education': val,
                              };
                            },
                          ),
                          const SizedBox(height: 12),
                          Text('Elementary', style: AppText.fontBold),
                          const SizedBox(height: 8),
                          AppInputField(
                            label: 'Year Graduated',
                            initialValue: tempUser.value['elem_year_grad'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'elem_year_grad': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Level Reached',
                            initialValue: tempUser.value['elem_level_reached'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'elem_level_reached': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Last Year Attended',
                            initialValue: tempUser.value['elem_year_last_attended'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'elem_year_last_attended': val
                              };
                            },
                          ),
                          const Divider(height: 20),

                          Text('High School', style: AppText.fontBold),
                          const SizedBox(height: 8),
                          AppInputField(
                            label: 'Year Graduated',
                            initialValue: tempUser.value['seco_year_grad'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'seco_year_grad': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Level Reached',
                            initialValue: tempUser.value['seco_level_reached'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'seco_level_reached': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Last Year Attended',
                            initialValue: tempUser.value['seco_year_last_attended'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'seco_year_last_attended': val
                              };
                            },
                          ),
                          const Divider(height: 20),

                          Text('Senior High School', style: AppText.fontBold),
                          const SizedBox(height: 8),
                          AppInputField(
                            label: 'SHS Strand',
                            initialValue: tempUser.value['shs_strand'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'shs_strand': val
                              };
                            },
                          ),
                          const Divider(height: 20),

                          Text('Tertiary', style: AppText.fontBold),
                          const SizedBox(height: 8),
                          AppInputField(
                            label: 'Program',
                            initialValue: tempUser.value['ter_course'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'ter_course': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Year Graduated',
                            initialValue: tempUser.value['ter_year_grad'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'ter_year_grad': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Level Reached',
                            initialValue: tempUser.value['ter_level_reached'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'ter_level_reached': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Last Year Attended',
                            initialValue: tempUser.value['ter_year_last_attended'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'ter_year_last_attended': val
                              };
                            },
                          ),
                          const Divider(height: 20),

                          // General Studies -------------------------------------------------
                          Text('General Studies', style: AppText.fontBold),
                          const SizedBox(height: 8),
                          AppInputField(
                            label: 'Program/Course',
                            initialValue: tempUser.value['gs_course'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'gs_course': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Year Graduated',
                            initialValue: tempUser.value['gs_year_grad'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'gs_year_grad': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Level Reached',
                            initialValue: tempUser.value['gs_level_reached'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'gs_level_reached': val
                              };
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: 'Last Year Attended',
                            initialValue: tempUser.value['gs_year_last_attended'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              tempUser.value = {
                                ...tempUser.value,
                                'gs_year_last_attended': val
                              };
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ).then((_) => setOpen());
        });
      }
      return null;
    }, [open]);


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
                'No educational background found.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (claims["role"] == "job_seeker")
                const Text(
                  'Please fill out your educational background to continue.',
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
                  onPressed: () => navigateTo(context, EducationalBackgroundForm(userId: claims['id'], fromProfile: true)), // opens modal form
                ),
            ],
          ),
        ),
      );
    }

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
                  'Educational Background',
                  style: AppText.textXl.merge(AppText.fontBold).merge(AppText.textLight)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.school, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      user.value['ter_course'] ?? 'N/A',
                      style: AppText.textLight.merge(AppText.fontSemibold)
                    )
                  )
                ],
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
                  Text(
                    user.value['ter_year_grad'] ?? 'N/A', 
                    style: AppText.textLight.merge(AppText.fontSemibold)
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AppButton(
                    label: 'Edit', 
                    onPressed: () => setOpen(),
                    backgroundColor: AppColor.light,
                    foregroundColor: AppColor.dark,
                    visualDensityY: -4,
                  )
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
              Text('Elementary Year Graduated:', style: AppText.fontBold),
              Text(user.value['elem_year_grad'] ?? 'N/A'),
              const SizedBox(height: 5),
              Text('Elementary Level Reached:', style: AppText.fontBold),
              Text(user.value['elem_year_grad'].isNotEmpty ? 'Grade Six' : user.value['elem_level_reached']),
              const SizedBox(height: 5),
              Text('Elementary Last Year Attended:', style: AppText.fontBold),
              Text(user.value['elem_year_grad'].isNotEmpty ? user.value['elem_year_grad'] : user.value['elem_year_last_attended']),
              const SizedBox(height: 20),

              Text('High School Year Graduated:', style: AppText.fontBold),
              Text(user.value['seco_year_grad'] ?? 'N/A'),
              const SizedBox(height: 5),
              Text('High School Level Reached:', style: AppText.fontBold),
              Text(user.value['seco_year_grad'].isNotEmpty ? 'Fourth Year' : user.value['seco_level_reached']),
              const SizedBox(height: 5),
              Text('High School Last Year Attended:', style: AppText.fontBold),
              Text(user.value['seco_year_grad'].isNotEmpty ? user.value['seco_year_grad'] : user.value['seco_year_last_attended']),
              const SizedBox(height: 20),

              Text('Senior High School Strand (Kto12):', style: AppText.fontBold),
              Text(user.value['shs_strand'] ?? 'N/A'),
              const SizedBox(height: 20),

              Text('Tertiary Level Reached:', style: AppText.fontBold),
              Text(user.value['ter_level_reached'].isEmpty ? 'N/A' : user.value['ter_level_reached']),
              const SizedBox(height: 5),
              Text('Tertiary Level Last Year Attended:', style: AppText.fontBold),
              Text(user.value['ter_year_last_attended'].isEmpty ? 'N/A' : user.value['ter_year_last_attended']),
              const SizedBox(height: 20),

              Text('General Studies Course/Program:', style: AppText.fontBold),
              Text(user.value['gs_course'].isEmpty ? 'N/A' : user.value['gs_course']),
              const SizedBox(height: 5),
              Text('General Studies Year Graduated:', style: AppText.fontBold),
              Text(user.value['gs_year_grad'].isEmpty ? 'N/A' : user.value['gs_year_grad']),
              const SizedBox(height: 5),
              Text('General Studies Reached:', style: AppText.fontBold),
              Text(user.value['gs_level_reached'].isEmpty ? 'N/A' : user.value['gs_level_reached']),
              const SizedBox(height: 5),
              Text('General Studies Last Year Attended:', style: AppText.fontBold),
              Text(user.value['gs_year_last_attended'].isEmpty ? 'N/A' : user.value['gs_year_last_attended']),
              const SizedBox(height: 20),

              Text('Fill up date:', style: AppText.fontBold),
              Text(user.value['created_at'].isEmpty ? 'N/A' : formatDateTime(user.value['created_at'])),
              const SizedBox(height: 20),
            ],
          ),
        )
    

      ],
    );
  }
}

