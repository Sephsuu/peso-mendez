import 'package:app/core/components/alert.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/features/employer/edit_job.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ViewActiveJobs extends HookWidget {
  final Function(PageType) onNavigate;
  final List<Map<String, dynamic>> jobs;

  const ViewActiveJobs({
    super.key,
    required this.onNavigate,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    final search = useState("");
    final filteredJobs = useState<List<Map<String, dynamic>>>([]);

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

    Future<void> handleDelete(int jobId) async {
      try {
        await JobService.deleteJob(jobId);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job successfully deleted")));
        Navigator.push(context, MaterialPageRoute(builder: (context) => EmployerDashboard(onNavigate: (page) => globalNavigateTo?.call(page))));
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
            const ViewActiveJosbHeader(),
            const SizedBox(height: 20),
            ViewActiveJobsFilter(setSearch: setSearch),
            const SizedBox(height: 20),
            ViewActiveJobsTable(jobs: filteredJobs.value, handleDelete: handleDelete),
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
  const ViewActiveJobsFilter({
    super.key,
    required this.setSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class ViewActiveJobsTable extends StatelessWidget {
  final List<Map<String, dynamic>> jobs;
  final Future<void> Function(int) handleDelete;

  const ViewActiveJobsTable({
    super.key,
    required this.jobs,
    required this.handleDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
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
              DataCell(Text(job['posted_on'] ?? 'N/A')),
              DataCell(Text(job['visibility'] ?? 'N/A')),
              DataCell(
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditJob(onNavigate: (page) => globalNavigateTo?.call(page), job: job)));
                      },
                      child: Text("Update", style: AppText.textSuccess),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => showAlertDelete(context, "Are you sure to delete job?", job["id"], handleDelete),
                      child: Text("Delete", style: AppText.textDanger),
                    ),
                  ],
                )
              ),
            ],
          );
        }).toList()
      ),
    );
  }
}