import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewApplications extends HookWidget {
  final List<Map<String, dynamic>> applications;

  const ViewApplications({super.key, 
    required this.applications,
  });

  @override
  Widget build(BuildContext context) {
    final filteredApplications = useState<List<Map<String, dynamic>>>([]);
    final selectedJob = useState("");
    final selectedLocation = useState("");
    final selectedStatus = useState("");

    final jobSelection = useState<List<String>>([]);
    final locationSelection = useState<List<String>>([]);

    void setJob(String newVal) {
      selectedJob.value = newVal;
    }

    void setLocation(String newVal) {
      selectedLocation.value = newVal;
    }

    void setStatus(String newVal) {
      selectedStatus.value = newVal;
    }

    useEffect(() {
      final jobs = applications.map((item) => item["title"].toString()).toSet().toList();
      final locations = applications.map((item) => item["location"].toString()).toSet().toList();

      jobSelection.value = ["All Jobs", ...jobs];
      locationSelection.value = ["All Locations", ...locations];
      filteredApplications.value = applications;
      return null;
    }, [applications]);

    useEffect(() {
      if (selectedJob.value.isNotEmpty && selectedJob.value != "All Jobs") {
        filteredApplications.value = filteredApplications.value.where((item) {
          return item["title"] == selectedJob.value;
        }).toList();
      } else if (selectedLocation.value.isNotEmpty && selectedJob.value != "All Locations") {
        filteredApplications.value = filteredApplications.value.where((item) {
          return item["location"] == selectedLocation.value;
        }).toList();
      } else if (selectedStatus.value.isNotEmpty && selectedStatus.value != "All Status") {
        filteredApplications.value = filteredApplications.value.where((item) {
          return item["status"] == selectedStatus.value;
        }).toList();
      } else {
        filteredApplications.value = applications;
      }
      return null;
    }, [selectedJob.value, selectedLocation.value, selectedStatus.value]);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Column(
                children: [
                  const ViewApplicationHeader(),
                  const SizedBox(height: 20),
                  ViewApplicationsFilter(jobs: jobSelection.value, locations: locationSelection.value, setJob: setJob, setLocation: setLocation, setStatus: setStatus),
                  const SizedBox(height: 20),
                  ViewApplicationsTable(applications: filteredApplications.value),
                ],
              ),
            ),
            const SizedBox(height: 200),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class ViewApplicationHeader extends StatelessWidget {
  const ViewApplicationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('📄 View Applications', style: AppText.textXl.merge(AppText.fontSemibold)),
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

class ViewApplicationsFilter extends StatelessWidget {
  final List<String> jobs;
  final List<String> locations;
  final ValueChanged<String> setJob;
  final ValueChanged<String> setLocation;
  final ValueChanged<String> setStatus;

  const ViewApplicationsFilter({
    super.key,
    required this.jobs,
    required this.locations,
    required this.setJob,
    required this.setLocation,
    required this.setStatus,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> statuses = ["All Status", "Sent", "Reviewed", "Interview", "Rejected", "Hired"];

    return Column(
      children: [
        ViewApplicationDropdownSelect(items: jobs, initialValue: "All Jobs", onChanged: setJob),
        const SizedBox(height: 7),
        ViewApplicationDropdownSelect(items: locations, initialValue: "All Locations", onChanged: setLocation),
        const SizedBox(height: 7),
        ViewApplicationDropdownSelect(items: statuses, initialValue: "All Status", onChanged: setStatus),
      ],
    );
  }
}

class ViewApplicationsTable extends StatelessWidget {
  final List<Map<String, dynamic>> applications;

  const ViewApplicationsTable({
    super.key,
    required this.applications
  });

  @override
  Widget build(BuildContext context) {
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
            DataColumn(label: Text('Applicant')),
            DataColumn(label: Text('Job Title')),
            DataColumn(label: Text('Job Location')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Applied On')),
            DataColumn(label: Text('Resume')),
            DataColumn(label: Text('Action')),
          ],
          rows: applications.map((application) {
            return DataRow(
              cells: [
                DataCell(Text(application['full_name'] ?? 'N/A')),
                DataCell(Text(application['title']?.toString() ?? 'N/A')),
                DataCell(Text(application['location'] ?? 'N/A')),
                DataCell(ViewApplicationUpdateStatus(initialValue: application["status"], applicationId: application["id"],)),
                DataCell(Text(formatDateTime(application['applied_on']))),
                DataCell(
                  application["document_path"] != null && application["document_path"].toString().isNotEmpty 
                    ? GestureDetector(
                      onTap: () async {
                        final String filePath = application["document_path"];
                        final String fullUrl = filePath.startsWith("http")
                            ? filePath
                            : "$BASE_URL/$filePath";

                        final Uri uri = Uri.parse(fullUrl);

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication, // opens in browser or PDF viewer
                          );
                        } else {
                          if (context.mounted) {
                            AppSnackbar.show(
                              context,
                              message: "Cannot open document",
                              backgroundColor: AppColor.danger
                            );
                          }
                        }
                      },
                      child: const Text(
                        'View Resume',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                    : const Text('No Resume')
                ),
                DataCell(Text(application['action'] ?? 'N/A')),
              ],
            );
          }).toList()
        )
      )
    );
  }
}