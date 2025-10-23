import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/employer/edit_job.dart';
import 'package:app/features/job_seeker/view_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const jobOptions = ['Active Jobs', 'Inactive Jobs'];

class ViewActiveJobs extends HookWidget {
  final List<Map<String, dynamic>> jobs;

  const ViewActiveJobs({
    super.key,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    final selectedJob = useState(jobOptions[0]);
    final reload = useState(false);
    final search = useState("");
    final filteredJobs = useState<List<Map<String, dynamic>>>([]);

    void setReload() {
      reload.value = !reload.value;
    }

    void setSelectedJob(String value) {
      selectedJob.value = value;
    }

    void setSearch(String newVal) {
      search.value = newVal;
    }

    useEffect(() {
      if (search.value.isEmpty) {
        filteredJobs.value = jobs;
      } else {
        filteredJobs.value = jobs.where((job) {
          final title = job["title"]?.toLowerCase() ?? '';
          return title.contains(search.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [search.value]);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            const ViewActiveJosbHeader(),
            const SizedBox(height: 20),
            ViewActiveJobsFilter(
              setSearch: setSearch,
              selectedJob: selectedJob.value,
              setSelectedJob: setSelectedJob,
            ),
            const SizedBox(height: 20),
            ViewActiveJobsTable(
              jobs: filteredJobs.value,
              setReload: setReload,
            ),
            const SizedBox(height: 300),
            const Footer()
          ],
        ),
      ),
    );
  }
}

class ViewActiveJosbHeader extends StatelessWidget {
  const ViewActiveJosbHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('💼 Your Active Jobs', style: AppText.textXl.merge(AppText.fontSemibold)),
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

class ViewActiveJobsFilter extends StatelessWidget {
  final ValueChanged<String> setSearch;
  final String selectedJob;
  final Function(String) setSelectedJob;

  const ViewActiveJobsFilter({
    super.key,
    required this.setSearch,
    required this.selectedJob,
    required this.setSelectedJob,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: jobOptions.map((item) {
            return AppButton(
              label: item,
              onPressed: () => setSelectedJob(item),
              disableShadow: true,
              backgroundColor: Colors.transparent,
              foregroundColor: selectedJob != item ? AppColor.muted : AppColor.primary,
            );
          }).toList()
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextField(
            style: AppText.textXs,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.light,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              labelText: 'Search a job by its title.',
              labelStyle: AppText.textSm,
              border: const OutlineInputBorder()
            ),
            onChanged: (value) => setSearch(value),
          ),
        )
      ],
    );
  }
}

class ViewActiveJobsTable extends StatelessWidget {
  final List<Map<String, dynamic>> jobs;
  final VoidCallback setReload;

  const ViewActiveJobsTable({
    super.key,
    required this.jobs,
    required this.setReload,
  });

  @override
  Widget build(BuildContext context) {

    void handleDelete(int id) async {
      try {
        final res = await JobService.deleteJob(id);
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Job deleted sucessfully!'
          );
          setReload();
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: 'Error $e'
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 215, 215, 215)),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ), 
        child: DataTable(
          headingRowHeight: 40,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 40,
          border: TableBorder.all(
            color: const Color.fromARGB(255, 191, 191, 191),
            width: 1,
          ),
          columns: const [
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Company')),
            DataColumn(label: Text('Location')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Salary')),
            DataColumn(label: Text('Visibility')),
            DataColumn(label: Text('Date Posted')),
            DataColumn(label: Text('Actions')),
          ],
          rows: jobs.map((job) {
            return DataRow(
              cells: [
                DataCell(Text(job['title'] ?? 'N/A')),
                DataCell(Text(job['company']?.toString() ?? 'N/A')),
                DataCell(Text(job['location'] ?? 'N/A')),
                DataCell(Text(job['type'] ?? 'N/A')),
                DataCell(Text(job['salary'] ?? 'N/A')),
                DataCell(
                  AppBadge(
                    text: job["visibility"],
                    color: job["visibility"] == 'Lite' ? const Color.fromARGB(255, 52, 32, 0) : job["visibility"] == 'Branded' ? const Color.fromARGB(255, 150, 150, 150) : const Color.fromARGB(255, 156, 101, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  )
                ),
                DataCell(Text(job['posted_on'] ?? 'N/A')),
                DataCell(
                  Row(
                    children: [
                      AppButton(
                        label: 'View', 
                        onPressed: () => navigateTo(context, ViewJob(jobId: job['id'])),
                        backgroundColor: AppColor.primary,
                        visualDensityY: -3,
                        textSize: 12,
                      ),
                      const SizedBox(width: 10),
                      AppButton(
                        label: 'Update', 
                        onPressed: () => navigateTo(context, EditJob(job: job)),
                        backgroundColor: AppColor.success,
                        visualDensityY: -3,
                        textSize: 12,
                      ),
                      const SizedBox(width: 10),
                      AppButton(
                        label: 'Delete', 
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AppModal(
                                title: 'Are you sure to delete job: ${job["title"]}',
                                titleStyle: AppText.fontSemibold.merge(AppText.textLg),
                                message: 'Warning: This action is irreversible.',
                                confirmLabel: "Confirm",
                                confirmBackground: AppColor.danger,
                                confirmForeground: AppColor.light,
                                onConfirm: () => handleDelete(job["id"]),
                              );
                            }
                          );
                        },
                        backgroundColor: AppColor.danger,
                        visualDensityY: -3,
                        textSize: 12,
                      ),
                    ],
                  )
                ),
              ],
            );
          }).toList()
        ),
      ),
    );
  }
}