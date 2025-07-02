import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/admin/employers_report.dart';
import 'package:app/features/admin/job_seekers_report.dart';
import 'package:app/features/admin/manage_users.dart';
import 'package:app/features/homepage.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final Function(PageType) onNavigate;
  const AdminDashboard({
    super.key,
    required this.onNavigate,
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
              AdminSummary(),
              const SizedBox(height: 15),
              EmployerVerificationQueue(),
              const SizedBox(height: 15),
              AdminActions(),
              const SizedBox(height: 15),
              PerformanceAndReports(),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminSummary extends StatefulWidget {
  const AdminSummary({Key? key}) : super(key: key);

  @override
  _AdminSummaryState createState() => _AdminSummaryState();
}
class _AdminSummaryState extends State<AdminSummary> {
  int usersCount = 0;
  int employersCount = 0;
  int jobSeekersCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final usersCountRes = await UserService.fetchUsersCount("users");
      final employersCountRes = await UserService.fetchUsersCount("employer");
      final jobSeekersCountRes = await UserService.fetchUsersCount("job_seeker");
      setState(() {
        usersCount = (usersCountRes["count"] ?? 0) as int;
        employersCount = (employersCountRes["count"] ?? 0) as int;
        jobSeekersCount = (jobSeekersCountRes["count"] ?? 0) as int;
      });
      isLoading = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(padding: EdgeInsets.only(top: 50),child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6));
    }
    
    return Column(
      children: [
        AdminSummaryCard(color: AppColor.primary, text: "Total Users", count: usersCount.toString()),
        AdminSummaryCard(color: AppColor.info, text: "Employers", count: employersCount.toString()),
        AdminSummaryCard(color: AppColor.success, text: "Job Seekers", count: jobSeekersCount.toString()),
        AdminSummaryCard(color: AppColor.secondary, text: "Announcements", count: "4"),
        SizedBox(height: 20),
        AdminSummaryCard(color: AppColor.warning, text: "Total Users", count: "4"),
        AdminSummaryCard(color: AppColor.dark, text: "Total Users", count: "4"),
      ],
    );
  }
}

class EmployerVerificationQueue extends StatefulWidget {
  const EmployerVerificationQueue({Key? key}) : super(key: key);

  @override
  _EmployerVerificationQueueState createState() => _EmployerVerificationQueueState();
}
class _EmployerVerificationQueueState extends State<EmployerVerificationQueue> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("🗂 Employer Verification Queue", style: AppText.textXl.merge(AppText.fontSemibold))
      ],
    );
  }
}

class AdminActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Admin Actions", style: AppText.textXl.merge(AppText.fontSemibold)),
        AdminActionButton(color: AppColor.dark, text: "Manage Users", page: ManageUsers(onNavigate: (page) => globalNavigateTo?.call(page))),
        AdminActionButton(color: AppColor.primary, text: "Post Announcement", page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page))),
        AdminActionButton(color: AppColor.warning, text: "Manage Events", page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page))),
        AdminActionButton(color: AppColor.info, text: "Manage Trainings", page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page))),
      ],
    );
  }
}

class PerformanceAndReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("📊 Performance & Reports", style: AppText.textXl.merge(AppText.fontSemibold)),
        AdminActionButton(color: AppColor.primary, text: "Users Report", page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page))),
        AdminActionButton(color: AppColor.info, text: "Employers Report", page: EmployersReport(onNavigate: (page) => globalNavigateTo?.call(page))),
        AdminActionButton(color: AppColor.success, text: "Job Seekers Report", page: JobSeekersReport(onNavigate: (page) => globalNavigateTo?.call(page))),
      ],
    );
  }
}