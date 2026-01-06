import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const caviteLocations = [
  "Alfonso","Amadeo","Bacoor City","Carmona","Cavite City","Cavite Province",
  "City of General Trias","Dasmariñas City","General Emilio Aguinaldo",
  "General Mariano Alvarez","Imus City","Indang","Kawit","Magallanes",
  "Maragondon","Mendez","Naic","Noveleta","Rosario","Silang","Tagaytay City",
  "Tanza","Ternate","Trece Martires City"
];

const educationLevels = [
  "No grade completed",
  "Elementary Level",
  "Elementary Graduate",
  "Junior High School Level",
  "Senior High School Graduate",
  "College Level",
  "College Graduate",
  "Master's Degree",
  "Doctorate Degree",
];

const employerTypes = [
  "Local - Private",
  "Local - Government",
  "Overseas",
  "Not Applicable",
];

class EmployerInformation extends HookWidget {
  final Map<String, dynamic> claims;

  const EmployerInformation({
    super.key,
    required this.claims,
  });

  String? safeSelectValue(dynamic value, List<String> items) {
    if (value == null) return null;
    final v = value.toString().trim();
    if (v.isEmpty) return null;
    return items.contains(v) ? v : null;
  }

  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final employer = useState<Map<String, dynamic>>({});
    final open = useState(false);

    void setOpen() {
      open.value = !open.value;
    }

    /// 🔹 FETCH DATA
    useEffect(() {
      if (claims['id'] == null) return null;

      () async {
        try {
          final data =
              await UserService.getEmployerInformation(claims['id']);
          employer.value = data;
        } catch (e) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "$e",
            backgroundColor: AppColor.danger,
          );
        } finally {
          loading.value = false;
        }
      }();

      return null;
    }, [claims['id']]);

    /// 🔹 UPDATE
    Future<void> handleSubmit() async {
      try {
        final res = await UserService.updateEmployerInformation({
          "employer_id": employer.value['employer_id'],
          "surname": employer.value['surname'],
          "first_name": employer.value['first_name'],
          "middle_name": employer.value['middle_name'],
          "date_of_birth": employer.value['date_of_birth'],
          "sex": employer.value['sex'],
          "citmun": employer.value['citmun'],
          "highest_education": employer.value['highest_education'],
          "employer_type": employer.value['employer_type'],
          "company_name": employer.value['company_name'],
          "company_address": employer.value['company_address'],
          "company_contact": employer.value['company_contact'],
        });

        if (res.isNotEmpty && context.mounted) {
          AppSnackbar.show(
            context,
            message: "Employer information updated successfully!",
            backgroundColor: AppColor.success,
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: "$e",
          backgroundColor: AppColor.danger,
        );
      }
    }

    /// 🔹 EDIT MODAL
    useEffect(() {
      if (!open.value) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AppModal(
            title: "Edit Employer Information",
            confirmBackground: AppColor.success,
            confirmForeground: AppColor.light,
            onConfirm: handleSubmit,
            message: SizedBox(
              height: 380,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppInputField(
                      label: "Surname",
                      visualDensityY: 0,
                      initialValue: employer.value['surname'],
                      onChanged: (v) =>
                          employer.value = {...employer.value, "surname": v},
                    ),
                    const SizedBox(height: 12),

                    AppInputField(
                      label: "First Name",
                      visualDensityY: 0,
                      initialValue: employer.value['first_name'],
                      onChanged: (v) =>
                          employer.value = {...employer.value, "first_name": v},
                    ),
                    const SizedBox(height: 12),

                    AppInputField(
                      label: "Middle Name",
                      visualDensityY: 0,
                      initialValue: employer.value['middle_name'],
                      onChanged: (v) =>
                          employer.value = {...employer.value, "middle_name": v},
                    ),
                    const SizedBox(height: 12),

                    DateTimeFormField(
                      decoration: const InputDecoration(
                        labelText: "Date of Birth",
                        border: OutlineInputBorder(),
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      initialValue: employer.value['date_of_birth'] != null
                          ? DateTime.tryParse(
                              employer.value['date_of_birth'].toString())
                          : null,
                      onChanged: (v) => employer.value = {
                        ...employer.value,
                        "date_of_birth": v?.toIso8601String()
                      },
                    ),
                    const SizedBox(height: 12),

                    AppSelect<String>(
                      placeholder: "Sex",
                      items: const ["Male", "Female", "Other"],
                      value: employer.value['sex'],
                      visualDensityY: 1,
                      onChanged: (v) =>
                          employer.value = {...employer.value, "sex": v},
                    ),
                    const SizedBox(height: 12),

                    AppSelect<String>(
                      placeholder: "City / Municipality",
                      items: caviteLocations,
                      value: safeSelectValue(
                        employer.value['citmun'],
                        caviteLocations,
                      ),
                      visualDensityY: 1,
                      onChanged: (v) =>
                          employer.value = {...employer.value, "citmun": v},
                    ),
                    const SizedBox(height: 12),

                    AppSelect<String>(
                      placeholder: "Highest Education",
                      items: educationLevels,
                      value: safeSelectValue(
                        employer.value['highest_education'],
                        educationLevels,
                      ),
                      visualDensityY: 1,
                      onChanged: (v) => employer.value =
                          {...employer.value, "highest_education": v},
                    ),

                    const SizedBox(height: 12),

                    AppSelect<String>(
                      placeholder: "Employer Type",
                      items: employerTypes,
                      value: safeSelectValue(
                        employer.value['employer_type'],
                        employerTypes,
                      ),
                      visualDensityY: 1,
                      onChanged: (v) => employer.value =
                          {...employer.value, "employer_type": v},
                    ),

                    const SizedBox(height: 12),

                    AppInputField(
                      label: "Company Name",
                      visualDensityY: 0,
                      initialValue: employer.value['company_name'],
                      required: true,
                      onChanged: (v) => employer.value =
                          {...employer.value, "company_name": v},
                    ),
                    const SizedBox(height: 12),

                    AppInputField(
                      label: "Company Address",
                      initialValue: employer.value['company_address'],
                      maxLine: 2,
                      visualDensityY: 0,
                      onChanged: (v) => employer.value =
                          {...employer.value, "company_address": v},
                    ),
                    const SizedBox(height: 12),

                    AppInputField(
                      visualDensityY: 0,
                      label: "Company Contact",
                      initialValue: employer.value['company_contact'],
                      onChanged: (v) => employer.value =
                          {...employer.value, "company_contact": v},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).then((_) => setOpen());
      });

      return null;
    }, [open.value]);

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Employer Information',
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),
      body: loading.value
        ? const Loader()
        : SingleChildScrollView(
            child: Column(
              children: [
                // 🔹 HEADER
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 32, 64, 192),
                        Color.fromARGB(255, 104, 129, 255),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employer.value['company_name']?.toString().isNotEmpty == true
                            ? employer.value['company_name']
                            : '—',
                        style: AppText.textXl
                            .merge(AppText.fontBold)
                            .merge(AppText.textLight),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        employer.value['company_address']?.toString().isNotEmpty ==
                                true
                            ? employer.value['company_address']
                            : 'Address not provided',
                        style: AppText.textLight,
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        label: "Edit",
                        onPressed: setOpen,
                        backgroundColor: AppColor.light,
                        foregroundColor: AppColor.dark,
                        visualDensityY: -4,
                      ),
                    ],
                  ),
                ),

                // 🔹 DETAILS
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(
                          label: "Company Contact",
                          value: employer.value['company_contact'],
                        ),
                        _infoRow(
                          label: "Surname",
                          value: employer.value['surname'],
                        ),
                        _infoRow(
                          label: "First Name",
                          value: employer.value['first_name'],
                        ),
                        _infoRow(
                          label: "Middle Name",
                          value: employer.value['middle_name'],
                        ),
                        _infoRow(
                          label: "Date of Birth",
                          value: employer.value['date_of_birth'] != null
                              ? formatDateTime(employer.value['date_of_birth'])
                              : null,
                        ),
                        _infoRow(
                          label: "Sex",
                          value: employer.value['sex'],
                        ),
                        _infoRow(
                          label: "City / Municipality",
                          value: employer.value['citmun'],
                        ),
                        _infoRow(
                          label: "Highest Education",
                          value: employer.value['highest_education'],
                        ),
                        _infoRow(
                          label: "Employer Type",
                          value: employer.value['employer_type'],
                        ),
                        _infoRow(
                          label: "Created At",
                          value: employer.value['created_at'] != null
                              ? formatDateTime(employer.value['created_at'])
                              : null,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

    );
  }
}

Widget _infoRow({required String label, dynamic value}) {
  final displayValue =
      value != null && value.toString().trim().isNotEmpty
          ? value.toString()
          : '—';

  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.fontBold),
        const SizedBox(height: 2),
        Text(displayValue),
      ],
    ),
  );
}

