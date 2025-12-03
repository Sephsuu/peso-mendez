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
import 'package:app/features/forms/job_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class JobReference extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const JobReference({
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
        final res = await UserService.updateUserJobReference(tempUser.value);
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: 'Credential updated successfully!',
            backgroundColor: AppColor.success,
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: '$e',
          backgroundColor: AppColor.danger,
        );
      }
    }

    useEffect(() {
      if (claims['id'] == null) return null;
      void fetchData() async {
        try {
          final data = await UserService.getUserJobReference(claims['id']);
          user.value = data;
          tempUser.value = Map<String, dynamic>.from(data);
        } finally {
          loading.value = false;
        }
      }

      fetchData();
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
                'No job references found.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please fill out your job references to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Fill Out Information',
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.light,
                onPressed: () => navigateTo(context,
                    JobReferenceForm(userId: claims['id'], fromProfile: true)),
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
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setDialogState) => AppModal(
                  title: 'Edit Job Reference',
                  titleStyle: AppText.fontBold.merge(AppText.textXl),
                  confirmBackground: AppColor.success,
                  confirmForeground: AppColor.light,
                  onConfirm: () => handleSubmit(),
                  message: SizedBox(
                    height: 500,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          AppSelect<String>(
                            placeholder: 'Occupation Type',
                            required: true,
                            items: const ['Part-Time', 'Full-Time'],
                            value: tempUser.value['occupation_type'],
                            getLabel: (v) => v,
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              setDialogState(() {});
                              tempUser.value = {
                                ...tempUser.value,
                                'occupation_type': val,
                              };
                            },
                          ),
                          const SizedBox(height: 12),
                          AppInputField(
                            label: 'Occupation 1',
                            required: true,
                            initialValue: tempUser.value['occupation1'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (value) {
                              setDialogState(() {});
                              tempUser.value = {
                                ...tempUser.value,
                                'occupation1': value
                              };
                            },
                          ),
                          const SizedBox(height: 12),
                          AppInputField(
                            label: 'Occupation 2',
                            required: true,
                            initialValue: tempUser.value['occupation2'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (value) {
                              setDialogState(() {});
                              tempUser.value = {
                                ...tempUser.value,
                                'occupation2': value
                              };
                            },
                          ),
                          const SizedBox(height: 12),
                          AppInputField(
                            label: 'Occupation 3',
                            required: true,
                            initialValue: tempUser.value['occupation3'],
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (value) {
                              setDialogState(() {});
                              tempUser.value = {
                                ...tempUser.value,
                                'occupation3': value
                              };
                            },
                          ),
                          const SizedBox(height: 20),
                          AppSelect<String>(
                            placeholder: 'Location Type',
                            required: true,
                            items: const ['Local', 'Overseas'],
                            value: tempUser.value['location_type'],
                            getLabel: (v) => v,
                            visualDensityY: 0,
                            textSize: 16,
                            onChanged: (val) {
                              setDialogState(() {});
                              tempUser.value = {
                                ...tempUser.value,
                                'location_type': val,
                                'location1': null,
                                'location2': null,
                                'location3': null,
                              };
                            },
                          ),
                          const SizedBox(height: 12),
                          tempUser.value['location_type'] == "Overseas"
                              ? AppInputField(
                                  label: 'Location 1',
                                  required: true,
                                  initialValue: tempUser.value['location1'],
                                  visualDensityY: 0,
                                  textSize: 16,
                                  onChanged: (val) {
                                    setDialogState(() {});
                                    tempUser.value = {
                                      ...tempUser.value,
                                      'location1': val
                                    };
                                  },
                                )
                              : AppSelect<String>(
                                  items: caviteLocations,
                                  required: true,
                                  value: safeValue(
                                      tempUser.value['location1'],
                                      caviteLocations),
                                  placeholder: "Location 1",
                                  getLabel: (v) => v,
                                  visualDensityY: 0,
                                  textSize: 16,
                                  onChanged: (val) {
                                    setDialogState(() {});
                                    tempUser.value = {
                                      ...tempUser.value,
                                      'location1': val
                                    };
                                  },
                                ),
                          const SizedBox(height: 12),
                          tempUser.value['location_type'] == "Overseas"
                              ? AppInputField(
                                  label: 'Location 2',
                                  required: true,
                                  initialValue: tempUser.value['location2'],
                                  visualDensityY: 0,
                                  textSize: 16,
                                  onChanged: (val) {
                                    setDialogState(() {});
                                    tempUser.value = {
                                      ...tempUser.value,
                                      'location2': val
                                    };
                                  },
                                )
                              : AppSelect<String>(
                                  items: caviteLocations,
                                  required: true,
                                  value: safeValue(
                                      tempUser.value['location2'],
                                      caviteLocations),
                                  placeholder: "Location 2",
                                  getLabel: (v) => v,
                                  visualDensityY: 0,
                                  textSize: 16,
                                  onChanged: (val) {
                                    setDialogState(() {});
                                    tempUser.value = {
                                      ...tempUser.value,
                                      'location2': val
                                    };
                                  },
                                ),
                          const SizedBox(height: 12),
                          tempUser.value['location_type'] == "Overseas"
                              ? AppInputField(
                                  label: 'Location 3',
                                  required: true,
                                  initialValue: tempUser.value['location3'],
                                  visualDensityY: 0,
                                  textSize: 16,
                                  onChanged: (val) {
                                    setDialogState(() {});
                                    tempUser.value = {
                                      ...tempUser.value,
                                      'location3': val
                                    };
                                  },
                                )
                              : AppSelect<String>(
                                  items: caviteLocations,
                                  required: true,
                                  value: safeValue(
                                      tempUser.value['location3'],
                                      caviteLocations),
                                  placeholder: "Location 3",
                                  getLabel: (v) => v,
                                  visualDensityY: 0,
                                  textSize: 16,
                                  onChanged: (val) {
                                    setDialogState(() {});
                                    tempUser.value = {
                                      ...tempUser.value,
                                      'location3': val
                                    };
                                  },
                                ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ).then((_) => setOpen());
        });
      }

      return null;
    }, [open]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          width: double.infinity,
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
                child: Text('Job Reference',
                    style: AppText.textXl
                        .merge(AppText.fontBold)
                        .merge(AppText.textLight)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.fact_check,
                      size: 15, color: AppColor.light),
                  const SizedBox(width: 5),
                  Text(user.value['occupation_type'] ?? 'N/A',
                      style: AppText.textLight.merge(AppText.fontSemibold))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 15, color: AppColor.light),
                  const SizedBox(width: 5),
                  Text(user.value['location_type'] ?? 'N/A',
                      style: AppText.textLight.merge(AppText.fontSemibold))
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (claims["role"] != "employer")
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
              Text('Occupation 1:', style: AppText.fontBold),
              Text(user.value['occupation1']),
              const SizedBox(height: 5),
              Text('Location 1:', style: AppText.fontBold),
              Text(user.value['location1']),
              const SizedBox(height: 5),
              Text('Occupation 2:', style: AppText.fontBold),
              Text(user.value['occupation2']),
              const SizedBox(height: 5),
              Text('Location 2:', style: AppText.fontBold),
              Text(user.value['location2']),
              const SizedBox(height: 5),
              Text('Occupation 3:', style: AppText.fontBold),
              Text(user.value['occupation3']),
              const SizedBox(height: 5),
              Text('Location 3:', style: AppText.fontBold),
              Text(user.value['location3']),
              const SizedBox(height: 5),
              Text('Fill up date:', style: AppText.fontBold),
              Text(formatDateTime(user.value['created_at'])),
              const SizedBox(height: 5),
            ],
          ),
        )
      ],
    );
  }
}

T? safeValue<T>(T? value, List<T> items) {
  return items.contains(value) ? value : null;
}
