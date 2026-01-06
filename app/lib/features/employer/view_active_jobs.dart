import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/employer/edit_job.dart';
import 'package:app/features/job_seeker/view_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const jobOptions = ['Active Jobs', 'Inactive Jobs'];

class ViewActiveJobs extends HookWidget {
  const ViewActiveJobs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final userId = claims['id'];

    final loading = useState(true);
    final selectedJob = useState(jobOptions[0]);
    final reload = useState(false);
    final search = useState("");
    final jobs = useState<List<Map<String, dynamic>>>([]);
    final filteredJobs = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      if (userId == null) return null;

      () async {
        loading.value = true;
        try {
          final jobsRes = await JobService.getJobsByEmployer(userId);
          jobs.value = jobsRes;
        } catch (e) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: e.toString(),
            backgroundColor: AppColor.danger,
          );
        } finally {
          loading.value = false;
        }
      }();

      return null;
    }, [userId, reload.value]);


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
        filteredJobs.value = jobs.value;
      } else {
        filteredJobs.value = jobs.value.where((job) {
          final title = job["title"]?.toLowerCase() ?? '';
          return title.contains(search.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [search.value, jobs.value]);

    useEffect(() {
      if (selectedJob.value == jobOptions[0]) {
        filteredJobs.value =
            jobs.value.where((job) => job['status'] == 'active').toList();
      } else {
        filteredJobs.value =
            jobs.value.where((job) => job['status'] == 'inactive').toList();
      }
      return null;
    }, [selectedJob.value, jobs.value]);


    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: loading.value 
        ? const Loader()
        : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            const ViewActiveJosbHeader(),
            const SizedBox(height: 10),
            ViewActiveJobsFilter(
              setSearch: setSearch,
              selectedJob: selectedJob.value,
              setSelectedJob: setSelectedJob,
            ),
            const SizedBox(height: 10),
            ViewActiveJobsTable(
              jobs: filteredJobs.value,
              setReload: setReload,
              selectedJob: selectedJob.value,
            ),
            const SizedBox(height: 300),
            const Footer()
          ],
        ),
      )
    );
  }
}

class ViewActiveJosbHeader extends StatelessWidget {
  const ViewActiveJosbHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("My Jobs Postings", style: AppText.textXl.merge(AppText.fontSemibold)),
              GestureDetector(
                child: Text('⬅️ Back', style: AppText.textPrimary,),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ), 
        const Divider(thickness: 1, height: 16),
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
  final String selectedJob;

  const ViewActiveJobsTable({
    super.key,
    required this.jobs,
    required this.setReload,
    required this.selectedJob,
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
            message: 'Job deleted successfully!',
            backgroundColor: AppColor.success
          );
          setReload();
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(context, message: 'Error $e');
      }
    }

    // ✅ Show a message if there are no jobs
    if (jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No ${selectedJob.toLowerCase()} found.',
            style: AppText.fontSemibold.merge(AppText.textLg),
          ),
        ),
      );
    }

    // ✅ Otherwise, show the data table
    return Scrollbar(
      thumbVisibility: true, 
      thickness: 8,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: scrollableTablePadding),
        scrollDirection: Axis.horizontal,
        child: DataTableTheme(
          data: DataTableThemeData(
            headingRowColor:
                WidgetStateProperty.all(const Color.fromARGB(255, 215, 215, 215)),
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
              // DataColumn(label: Text('Visibility')),
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
                  DataCell(Text(formatToPeso(job['salary']))),
                  // DataCell(
                  //   AppBadge(
                  //     text: job["visibility"],
                  //     color: job["visibility"] == 'Lite'
                  //         ? const Color.fromARGB(255, 52, 32, 0)
                  //         : job["visibility"] == 'Branded'
                  //             ? const Color.fromARGB(255, 150, 150, 150)
                  //             : const Color.fromARGB(255, 156, 101, 0),
                  //     padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   ),
                  // ),
                  DataCell(Text(job['posted_on'] ?? 'N/A')),
                  DataCell(
                    Row(
                      children: [
                        AppButton(
                          label: 'View',
                          onPressed: () =>
                              navigateTo(context, ViewJob(jobId: job['id'])),
                          backgroundColor: AppColor.primary,
                          visualDensityY: -3,
                          textSize: 12,
                        ),
                        const SizedBox(width: 10),
                        AppButton(
                          label: 'Update',
                          onPressed: () =>
                              navigateTo(context, EditJob(job: job)),
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
                                  title:
                                      'Are you sure to delete job: ${job["title"]}',
                                  titleStyle:
                                      AppText.fontSemibold.merge(AppText.textLg),
                                  message:
                                      'Warning: This action is irreversible.',
                                  confirmLabel: "Confirm",
                                  confirmBackground: AppColor.danger,
                                  confirmForeground: AppColor.light,
                                  onConfirm: () => handleDelete(job["id"]),
                                );
                              },
                            );
                          },
                          backgroundColor: AppColor.danger,
                          visualDensityY: -3,
                          textSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}