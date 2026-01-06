import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/job_seeker/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

final placements = ["Hired (Local - Private)","Hired (Local - Government)","Hired (Overseas)","Not Hired","Undergone Training","Provided Livelihood","Not Applicable"];
final statuses = ["Sent", "Reviewed", "Interview", "Rejected", "Hired"];

class ViewApplications extends HookWidget {
  const ViewApplications({super.key, 
  });

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final userId = claims['id'];

    final loading = useState(true);
    final reload = useState(false);
    final applications = useState<List<Map<String, dynamic>>>([]);
    final filteredApplications = useState<List<Map<String, dynamic>>>([]);
    final selectedJob = useState("");
    final selectedLocation = useState("");
    final selectedStatus = useState("");

    final jobSelection = useState<List<String>>([]);
    final locationSelection = useState<List<String>>([]);
    final selectedStatusMap = useState<Map<int, String?>>({});
    final selectedPlacementMap = useState<Map<int, String?>>({});



    void setReload() {
      reload.value = !reload.value;
    }

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
      if (userId == null) return null;

      () async {
        loading.value = true;
        try {
          final applicationsRes =
              await ApplicationService.getApplicationsByEmployer(userId);
          applications.value = applicationsRes;
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

    useEffect(() {
      final jobs = applications.value.map((item) => item["title"].toString()).toSet().toList();
      final locations = applications.value.map((item) => item["location"].toString()).toSet().toList();

      jobSelection.value = ["All Jobs", ...jobs];
      locationSelection.value = ["All Locations", ...locations];
      filteredApplications.value = applications.value;
      return null;
    }, [applications.value]);

    useEffect(() {
      List<Map<String, dynamic>> temp = applications.value;

      if (selectedJob.value.isNotEmpty && selectedJob.value != "All Jobs") {
        temp = temp.where((item) => item["title"] == selectedJob.value).toList();
      }

      if (selectedLocation.value.isNotEmpty && selectedLocation.value != "All Locations") {
        temp = temp.where((item) => item["location"] == selectedLocation.value).toList();
      }

      if (selectedStatus.value.isNotEmpty && selectedStatus.value != "All Status") {
        temp = temp.where((item) => item["status"] == selectedStatus.value).toList();
      }

      filteredApplications.value = temp;

      return null;
    }, [
      selectedJob.value,
      selectedLocation.value,
      selectedStatus.value,
      applications.value,
    ]);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: loading.value
        ? const Loader()
        : SingleChildScrollView(
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
                  ViewApplicationsTable(
                    applications: filteredApplications.value,
                    setReload: setReload,
                    selectedStatusMap: selectedStatusMap,
                    selectedPlacementMap: selectedPlacementMap,
                  ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Manage Applications", style: AppText.textXl.merge(AppText.fontSemibold)),
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
  final VoidCallback setReload;
  final ValueNotifier<Map<int, String?>> selectedStatusMap;
  final ValueNotifier<Map<int, String?>> selectedPlacementMap; 

  const ViewApplicationsTable({
    super.key,
    required this.applications,
    required this.setReload,
    required this.selectedStatusMap,
    required this.selectedPlacementMap,
  });

  void _updateStatus(BuildContext context, int id, String status) async {
    try {
      final data = await ApplicationService.updateApplicationStatus(id, status);
      if (data.isNotEmpty) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: "Application status updated successfully!",
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

  void viewResume(int userId, BuildContext context) async {
    try {
      await UserService.generateResume(userId);
      print("JEOB $userId");
      final rawUrl = "$BASE_URL/uploads/job-seeker-resume/${userId}_resume.pdf";

      final viewerUrl = "https://docs.google.com/gview?embedded=true&url=$rawUrl";
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("Applicant Resume")),
            body: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(viewerUrl),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      AppSnackbar.show(
        context,
        message: "Applicant resume is not available.",
        backgroundColor: AppColor.danger,
      );
    }
  }

  void _updatePlacement(BuildContext context, int id, String placement) async {
    try {
      final data = await ApplicationService.updateApplicationPlacement(id, placement);
      
      if (data.isNotEmpty) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: "Placement updated successfully!",
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


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true, 
      thickness: 8,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: scrollableTablePadding),
        scrollDirection: Axis.horizontal,
        child: DataTableTheme(
          data: DataTableThemeData(
            headingRowColor: WidgetStateProperty.all(
              const Color.fromARGB(255, 215, 215, 215),
            ),
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
              DataColumn(label: Text("Placement")),
              DataColumn(label: Text('Applied On')),
              DataColumn(label: Text('Action')),
            ],
            rows: applications.map((application) {
              final appId = application['id'];

              return DataRow(
                cells: [
                  DataCell(Text(application['full_name'] ?? 'N/A')),
                  DataCell(Text(application['title']?.toString() ?? 'N/A')),
                  DataCell(Text(application['location'] ?? 'N/A')),
                  DataCell(
                    AppSelect<String>(
                      items: statuses,
                      value: selectedStatusMap.value[appId] ?? application["status"],
                      placeholder: "Status",
                      borderColor: AppColor.muted,
                      getLabel: (item) => item,
                      onChanged: (value) async {
                        bool? confirmed = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirm Change"),
                            content: Text(
                              "Are you sure you want to change status to \"$value\"?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text("Confirm"),
                              ),
                            ],
                          ),
                        );
                        if (!context.mounted) return;
                        if (confirmed == true) {
                          selectedStatusMap.value = {
                            ...selectedStatusMap.value,
                            appId: value,
                          };
                          _updateStatus(context, appId, value!);
                        }
                      },
                    ),
                  ),
                  DataCell(
                    AppSelect<String>(
                      items: placements,
                      value: selectedPlacementMap.value[appId] ?? application["placement"],
                      placeholder: "Placement",
                      getLabel: (item) => item,
                      borderColor: AppColor.muted,
                      onChanged: (value) async {
                        bool? confirmed = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirm Change"),
                            content: Text(
                              "Are you sure you want to change placement to \"$value\"?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text("Confirm"),
                              ),
                            ],
                          ),
                        );
                        if (!context.mounted) return;
                        if (confirmed == true) {
                          selectedPlacementMap.value = {
                            ...selectedPlacementMap.value,
                            appId: value,
                          };
                          _updatePlacement(context, appId, value!);
                        }
                      },
                    ),
                  ),
                  DataCell(Text(formatDateTime(application['applied_on']))),
                  /// ACTION --------
                  DataCell(
                    AppButton(
                      label: "View Profile",
                      onPressed: () {
                        navigateTo(
                          context,
                          EditProfile(
                            employerClaim: {
                              "id": application['job_seeker_id'],
                              "role": "employer"
                            },
                          ),
                        );
                      },
                      backgroundColor: AppColor.primary,
                      visualDensityY: -2,
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
