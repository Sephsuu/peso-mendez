import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/admin/employers_report.dart';
import 'package:app/features/admin/job_seekers_report.dart';
import 'package:app/features/admin/manage_users.dart';
import 'package:app/features/admin/post_announcement.dart';
import 'package:app/features/homepage.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Text("Administrator Dashboard", style: AppText.textXl.merge(AppText.fontSemibold)),
              const AdminSummary(),
              const SizedBox(height: 15),
              const EmployerVerificationQueue(),
              const SizedBox(height: 15),
              const AdminActions(),
              const SizedBox(height: 15),
              const PerformanceAndReports(),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminSummary extends HookWidget {
  const AdminSummary({ super.key });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final users = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      void fetchData() async {
        try {
          final res = await UserService.getAllUsers();
          users.value = res;
        } catch(e) { 
          if (!context.mounted) return;
          showAlertError(context, "Error: $e"); 
        }
        finally { loading.value = false; }
      }
      fetchData();
      return null;
    }, []);

    final usersCount = users.value.length;
    final employersCount = users.value.where((i) => i["role"] == "employer").length;
    final jobSeekersCount = users.value.where((i) => i["role"] == "employer").length;

    if (loading.value) {
      return const Padding(padding: EdgeInsets.only(top: 50),child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6));
    }
    
    return Column(
      children: [
        AdminSummaryCard(color: AppColor.primary, text: "Total Users", count: usersCount.toString()),
        AdminSummaryCard(color: AppColor.info, text: "Employers", count: employersCount.toString()),
        AdminSummaryCard(color: AppColor.success, text: "Job Seekers", count: jobSeekersCount.toString()),
        const AdminSummaryCard(color: AppColor.secondary, text: "Announcements", count: "4"),
        const SizedBox(height: 20),
        const AdminSummaryCard(color: AppColor.warning, text: "Total Users", count: "4"),
        const AdminSummaryCard(color: AppColor.dark, text: "Total Users", count: "4"),
      ],
    );
  }
}

class EmployerVerificationQueue extends HookWidget {
  const EmployerVerificationQueue({super.key});

  @override
  Widget build(BuildContext context) {
    final reload = useState(false);
    final employerVerifications = useState<List<Map<String, dynamic>>>([]);

    void setReload() {
      reload.value = !reload.value;
    }

    useEffect(() {
      void fetchData() async {
        try {
          final res = await VerificationService.getVerificationsByRole('employer');
          employerVerifications.value = res;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Error: $e"); 
        }
      }
      fetchData();
      return;
    }, [reload.value]);

    Future<void> handleSubmit(id, status) async {
      try {
        final res = await VerificationService.updateVerificationStatus(id, status);
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employer verification status updated successfully!'))
          );
          setReload();
        }
      } catch (e) { 
        if (!context.mounted) return;
        showAlertError(context, '$e');
      }
    }

    return Column(
      children: [
        Text("🗂 Employer Verification Queue", style: AppText.textXl.merge(AppText.fontSemibold)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Employer Name')),
              DataColumn(label: Text('E-mail Address')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ], 
            rows: employerVerifications.value.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['full_name'])),
                  DataCell(Text(item['email'])),
                  DataCell(Text(item['status'])),
                  DataCell(
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            visualDensity: const VisualDensity(vertical: -3),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            foregroundColor: AppColor.light,
                            backgroundColor: AppColor.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                            )
                          ),
                          onPressed: () async {
                            handleSubmit(item['id'], 'approved');
                          }, 
                          child: Text('Approve', style: AppText.textXs)
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            visualDensity: const VisualDensity(vertical: -3),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            foregroundColor: AppColor.light,
                            backgroundColor: AppColor.danger,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                            )
                          ),
                          onPressed: () async {
                            await handleSubmit(item['id'], 'rejected');
                          }, 
                          child: Text('Reject', style: AppText.textXs)
                        ),
                      ],
                    )
                  )
                ]
              );
            }).toList()
          ),
        )
      ],
    );
  }
}

class AdminActions extends StatelessWidget {
  const AdminActions({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Admin Actions", style: AppText.textXl.merge(AppText.fontSemibold)),
        const AdminActionButton(
          color: AppColor.dark, 
          text: "Manage Users", 
          page: ManageUsers()
        ),
        AdminActionButton(
          color: AppColor.primary, 
          text: "Post Announcement", 
          page: PostAnnouncement(onNavigate: (page) => globalNavigateTo?.call(page))
        ),
        AdminActionButton(
          color: AppColor.warning, 
          text: "Manage Events", 
          page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page))
        ),
        AdminActionButton(
          color: AppColor.info, 
          text: "Manage Trainings", 
          page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page))
        ),
      ],
    );
  }
}

class PerformanceAndReports extends StatelessWidget {
  const PerformanceAndReports({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("📊 Performance & Reports", style: AppText.textXl.merge(AppText.fontSemibold)),
        AdminActionButton(
          color: AppColor.primary, 
          text: "Users Report", 
          page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page))
        ),
        const AdminActionButton(
          color: AppColor.info, 
          text: "Employers Report", page: 
          EmployersReport()
        ),
        AdminActionButton(
          color: AppColor.success, 
          text: "Job Seekers Report", 
          page: JobSeekersReport(onNavigate: (page) => globalNavigateTo?.call(page))
        ),
      ],
    );
  }
}