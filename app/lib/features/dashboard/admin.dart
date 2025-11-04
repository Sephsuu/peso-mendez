import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/announcement_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/admin/employers_report.dart';
import 'package:app/features/admin/job_seekers_report.dart';
import 'package:app/features/admin/manage_users.dart';
import 'package:app/features/admin/post_announcement.dart';
import 'package:app/features/shared/announcements.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _SectionHeader(title: "Administrator Dashboard"),
            SizedBox(height: 15),
            AdminSummary(),
            SizedBox(height: 20),
            EmployerVerificationQueue(),
            SizedBox(height: 15),
            AdminActions(),
            SizedBox(height: 15),
            PerformanceAndReports(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(title, style: AppText.textXl.merge(AppText.fontSemibold)),
    );
  }
}

// =============================
//  ADMIN SUMMARY SECTION
// =============================
class AdminSummary extends HookWidget {
  const AdminSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final users = useState<List<Map<String, dynamic>>>([]);
    final announcements = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      void fetchData() async {
        try {
          final res = await UserService.getAllUsers();
          final announcementRes = await AnnouncementService.getAllAnnouncements();
          users.value = res;
          announcements.value = announcementRes;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Error: $e");
        } finally {
          loading.value = false;
        }
      }

      fetchData();
      return null;
    }, []);

    if (loading.value) return const Loader();

    final usersCount = users.value.length;
    final employersCount = users.value.where((i) => i["role"] == "employer").length;
    final jobSeekersCount = users.value.where((i) => i["role"] == "job_seeker").length;
    final announcementsCount = announcements.value.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AdminSummaryCard(
                  color: AppColor.primary,
                  text: "Total Users",
                  count: usersCount.toString(),
                  navigateTo: () => navigateTo(context, const ManageUsers()),
                ),
              ),
              Expanded(
                child: AdminSummaryCard(
                  color: AppColor.info,
                  text: "Employers",
                  count: employersCount.toString(),
                  navigateTo: () => navigateTo(context, const EmployersReport()),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: AdminSummaryCard(
                  color: AppColor.success,
                  text: "Job Seekers",
                  count: jobSeekersCount.toString(),
                  navigateTo: () => navigateTo(context, const JobSeekersReport()),
                ),
              ),
              Expanded(
                child: AdminSummaryCard(
                  color: AppColor.secondary,
                  text: "Announcements",
                  count: announcementsCount.toString(),
                  navigateTo: () => navigateTo(context, const Announcements()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ====================================
//  EMPLOYER VERIFICATION QUEUE
// ====================================
class EmployerVerificationQueue extends HookWidget {
  const EmployerVerificationQueue({super.key});

  @override
  Widget build(BuildContext context) {
    final reload = useState(false);
    final verifications = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      () async {
        try {
          verifications.value = await VerificationService.getVerificationsByRole('');
        } catch (e) {
          if (context.mounted) showAlertError(context, "Error: $e");
        }
      }();
      return;
    }, [reload.value]);

    Future<void> updateStatus(id, status) async {
      try {
        await VerificationService.updateVerificationStatus(id, status);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status updated successfully!')),
          );
          reload.value = !reload.value;
        }
      } catch (e) {
        if (context.mounted) showAlertError(context, '$e');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🗂 Employer Verification Queue",
              style: AppText.textXl.merge(AppText.fontSemibold)),
          const SizedBox(height: 16),
          verifications.value.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      'No employer verifications found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Employer Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: verifications.value.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item['full_name'] ?? '—')),
                        DataCell(Text(item['email'] ?? '—')),
                        DataCell(Text(item['status'] ?? '—')),
                        DataCell(Row(children: [
                          AppButton(
                            label: 'Approve',
                            backgroundColor: AppColor.success,
                            onPressed: () => updateStatus(item['id'], 'approved'),
                            visualDensityY: -3,
                          ),
                          const SizedBox(width: 5),
                          AppButton(
                            label: 'Reject',
                            backgroundColor: AppColor.danger,
                            onPressed: () => updateStatus(item['id'], 'rejected'),
                            visualDensityY: -3,
                          ),
                        ])),
                      ]);
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }
}

// =====================
//  ADMIN ACTION BUTTONS
// =====================
class AdminActions extends StatelessWidget {
  const AdminActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text("Admin Actions",
              style: AppText.textXl.merge(AppText.fontSemibold)),
          const AdminActionButton(
            color: AppColor.dark,
            text: "Manage Users",
            page: ManageUsers(),
          ),
          AdminActionButton(
            color: AppColor.primary,
            text: "Post Announcement",
            page: PostAnnouncement(onNavigate: (page) => globalNavigateTo?.call(page)),
          ),
        ],
      ),
    );
  }
}

// =======================
//  PERFORMANCE & REPORTS
// =======================
class PerformanceAndReports extends StatelessWidget {
  const PerformanceAndReports({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text("📊 Performance & Reports",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          AdminActionButton(
            color: AppColor.primary,
            text: "Users Report",
            page: ManageUsers(),
          ),
          AdminActionButton(
            color: AppColor.info,
            text: "Employers Report",
            page: EmployersReport(),
          ),
          AdminActionButton(
            color: AppColor.success,
            text: "Job Seekers Report",
            page: JobSeekersReport(),
          ),
        ],
      ),
    );
  }
}
