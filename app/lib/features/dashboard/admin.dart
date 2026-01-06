import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/announcement_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/admin/employers_report.dart';
import 'package:app/features/admin/job_seekers_report.dart';
import 'package:app/features/admin/manage_users.dart';
import 'package:app/features/admin/post_announcement.dart';
import 'package:app/features/admin/reports/citmun.dart';
import 'package:app/features/admin/reports/clientele.dart';
import 'package:app/features/admin/reports/employer_types.dart';
import 'package:app/features/admin/reports/genders.dart';
import 'package:app/features/admin/reports/highest_education.dart';
import 'package:app/features/admin/reports/placements.dart';
import 'package:app/features/admin/view_employer_documents.dart';
import 'package:app/features/shared/announcements.dart';
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
            ClienteleChart(),
            SizedBox(height: 15),
            GenderChart(),
            SizedBox(height: 15),
            PlacementChart(),
            SizedBox(height: 15),
            EmployerTypeChart(),
            SizedBox(height: 15),
            HighestEducationChart(),
            SizedBox(height: 15),
            CitmunChart(),
            SizedBox(height: 15),
            AdminActions(),
            SizedBox(height: 15),
            PerformanceAndReports(),
            SizedBox(height: 50),
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

    final usersCount = users.value.where((i) => i["status"] == "active").length;
    final employersCount = users.value.where((i) => i["role"] == "employer" && i["status"] == "active").length;
    final jobSeekersCount = users.value.where((i) => i["role"] == "job_seeker" && i["status"] == "active").length;
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
    final claims = useClaimsHook(context);
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
              : Scrollbar(
                  thumbVisibility: true, 
                  thickness: 8,
                  radius: const Radius.circular(8),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: scrollableTablePadding),
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
                              label: 'View Documents',
                              backgroundColor: AppColor.primary,
                              onPressed: () => navigateTo(context, ViewEmployerDocuments(claims: claims, employerId: item["employer_id"])),
                              visualDensityY: -3,
                            ),
                          ])),
                        ]);
                      }).toList(),
                    ),
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
          const AdminActionButton(
            color: AppColor.primary,
            text: "Post Announcement",
            page: const PostAnnouncement(),
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
