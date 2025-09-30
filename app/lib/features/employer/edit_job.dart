import 'package:app/core/components/alert.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class EditJob extends HookWidget {
  final Map<String, dynamic> job;

  const EditJob({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final updateJob = useState<Map<String, dynamic>>(job);

    void onFieldChanged(String key, dynamic value) {
      updateJob.value = {
        ...updateJob.value,
        key: value,
      };
    }

    // Handles job update
    void handleUpdate() async {
      try {
        await JobService.updateJob(updateJob.value);
        if (!context.mounted) return;
        navigateTo(context, const EmployerDashboard());
      } catch (e) {
        if (!context.mounted) return;
        showAlertError(context, "Failed to update job, please try again");
      }
    }

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            EditJobHeader(),
            EditJobForm(job: updateJob.value, onFieldChanged: onFieldChanged),
            EditJobButtons(handleUpdate: handleUpdate),
          ],
        ),
      ),
    );
  }
}

class EditJobHeader extends StatelessWidget {
  const EditJobHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('✏️ Edit Job Post', style: AppText.textXl.merge(AppText.fontSemibold)),
        GestureDetector(
          child: Text('⬅️ Back', style: AppText.textPrimary,),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class EditJobForm extends StatelessWidget {
  final Map<String, dynamic> job;
  final void Function(String fieldName, dynamic value) onFieldChanged;

  const EditJobForm({
    super.key,
    required this.job,
    required this.onFieldChanged
  });
  @override
  Widget build(BuildContext context) {
    final List<String> jobTypes = ["Full-time", "Part-time"];
    final List<String> visibilities = ["Lite", "Branded", "Premium"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextFormField(
          initialValue: job["title"],
          decoration: const InputDecoration(
            labelText: 'Job Title',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),  // Adds a default outline border
          ),
          onChanged: (value) => onFieldChanged("title", value),
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: job["company"],
          decoration: const InputDecoration(
            labelText: 'Company',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),  // Adds a default outline border
          ),
          onChanged: (value) => onFieldChanged("company", value),
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: job["location"],
          decoration: const InputDecoration(
            labelText: 'Job Location',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),  // Adds a default outline border
          ),
          onChanged: (value) => onFieldChanged("location", value),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Job Type',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
          value: job["type"],  // current selected value
          items: jobTypes.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onFieldChanged("type", value);
            }
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          initialValue: job["salary"],
          decoration: const InputDecoration(
            labelText: 'Job Salary',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),  // Adds a default outline border
          ),
          onChanged: (value) => onFieldChanged("salary", value),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Visibility',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),
          ),
          value: job["visibility"],  // current selected value
          items: visibilities.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onFieldChanged("visibility", value);
            }
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          maxLines: 3,
          initialValue: job["description"],
          decoration: const InputDecoration(
            labelText: 'Job Description',
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            border: OutlineInputBorder(),  // Adds a default outline border
          ),
          onChanged: (value) => onFieldChanged("description", value),
        ),
      ],
    );
  }
}

class EditJobButtons extends StatelessWidget {
  final VoidCallback handleUpdate;

  const EditJobButtons({
    super.key,
    required this.handleUpdate,
  }); 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColor.light,
            backgroundColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            )
          ),
          onPressed: handleUpdate, 
          child: const Text("💾 Save Changes")
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColor.light,
            backgroundColor: AppColor.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            )
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }, 
          child: const Text("Cancel")
        ),
      ],
    );
  }
}