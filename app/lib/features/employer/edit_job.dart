import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const caviteLocations = [
  "Alfonso","Amadeo","Bacoor City","Carmona","Cavite City","Cavite Province",
  "City of General Trias","Dasmariñas City","General Emilio Aguinaldo",
  "General Mariano Alvarez","Imus City","Indang","Kawit","Magallanes",
  "Maragondon","Mendez","Naic","Noveleta","Rosario","Silang",
  "Tagaytay City","Tanza","Ternate","Trece Martires City"
];

class EditJob extends HookWidget {
  final Map<String, dynamic> job;

  const EditJob({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final updateJob = useState<Map<String, dynamic>>(job);
    final selectedSkills = useState<List<String>>([]);
    final selectedCitmun = useState<String?>(job["citmun"]);

    useEffect(() {
      Future<void> fetchData() async {
        try {
          final data = await JobService.getJobSkills(job["id"]);
          selectedSkills.value = data.map<String>((e) => e["skill"]).toList();
          loading.value = false;
        } catch (e) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "$e",
            backgroundColor: AppColor.danger,
          );
        }
      }

      fetchData();
      return null;
    }, []);

    void onFieldChanged(String key, dynamic value) {
      updateJob.value = {
        ...updateJob.value,
        key: value,
      };
    }

    Future<void> handleUpdate() async {
      try {
        final data = await JobService.updateJob(updateJob.value);
        if (data.isNotEmpty) {
          // await JobService.updateJobSkills(
          //   updateJob.value["id"],
          //   selectedSkills.value,
          // );
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "Job updated successfully.",
            backgroundColor: AppColor.success,
          );
          navigateTo(context, const EmployerDashboard());
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

    if (loading.value) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) {
          Scaffold.of(context).openDrawer();
        },
      ),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('✏️ Edit Job Post',
                style: AppText.textXl.merge(AppText.fontSemibold)),
            const SizedBox(height: 20),
            const Text('Job title'),
            const SizedBox(height: 5),
            AppInputField(
              label: '',
              initialValue: updateJob.value["title"],
              required: true,
              visualDensityY: 0,
              validatorMessage: "This field is required.",
              onChanged: (v) => onFieldChanged("title", v),
            ),
            const SizedBox(height: 10),
            const Text('Company'),
            const SizedBox(height: 5),
            AppInputField(
              label: '',
              initialValue: updateJob.value["company"],
              required: true,
              visualDensityY: 0,
              validatorMessage: "This field is required.",
              onChanged: (v) => onFieldChanged("company", v),
            ),
            const SizedBox(height: 10),
          const Text('Job Location'),
          const SizedBox(height: 5),
            AppInputField(
              label: '',
              initialValue: updateJob.value["location"],
              required: true,
              visualDensityY: 0,
              validatorMessage: "This field is required.",
              onChanged: (v) => onFieldChanged("location", v),
            ),
            const SizedBox(height: 10),
            Text('City/Municipality', style: AppText.textSm),
            const SizedBox(height: 5),
            AppSelect<String>(
              items: caviteLocations,
              value: selectedCitmun.value,
              getLabel: (e) => e,
              visualDensityY: 2,
              onChanged: (v) {
                if (v != null) {
                  selectedCitmun.value = v;
                  onFieldChanged("citmun", v);
                }
              },
            ),
            const SizedBox(height: 10),
            Text('Job Type', style: AppText.textSm),
            const SizedBox(height: 5),
            AppSelect<String>(
              items: const ["Full-Time", "Part-Time"],
              value: updateJob.value["type"],
              getLabel: (e) => e,
              visualDensityY: 2,
              onChanged: (v) {
                if (v != null) onFieldChanged("type", v);
              },
            ),
            const SizedBox(height: 10),
            const Text('Salary'),
            const SizedBox(height: 5),
            AppInputField(
              label: 'Salary',
              numericOnly: true,
              initialValue: updateJob.value["salary"].toString(),
              onChanged: (v) {
                final n = double.tryParse(v);
                if (n != null) onFieldChanged("salary", n);
              },
            ),
            const SizedBox(height: 10),
            const Text('Job Description'),
            const SizedBox(height: 5),
            AppInputField(
              label: 'Job Description',
              initialValue: updateJob.value["description"],
              maxLine: 4,
              onChanged: (v) => onFieldChanged("description", v),
            ),
            const SizedBox(height: 20),

            const Text('Required Skills'),
            const SizedBox(height: 10),

            if (selectedSkills.value.isEmpty)
              Text("No selected skill for the job.",
                  style: AppText.textMuted),

            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 8) / 2;

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      List.generate(selectedSkills.value.length, (index) {
                    return SizedBox(
                      width: width,
                      child: GestureDetector(
                        onTap: () {
                          selectedSkills.value =
                              [...selectedSkills.value]..removeAt(index);
                        },
                        child: AppBadge(
                          text: selectedSkills.value[index],
                          backgroundColor: AppColor.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                AppButton(
                  label: '💾 Save Changes',
                  onPressed: handleUpdate,
                  backgroundColor: AppColor.success,
                ),
                const SizedBox(width: 10),
                AppButton(
                  label: 'Cancel',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: AppColor.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
