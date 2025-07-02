import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/employer/view_applications.dart';
import 'package:app/features/homepage.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class EmployerDashboard extends StatefulWidget {
  final Function(PageType) onNavigate;

  const EmployerDashboard({super.key, required this.onNavigate });

  @override
  _EmployerDashboardState createState() => _EmployerDashboardState();
}
class _EmployerDashboardState extends State<EmployerDashboard> {
  late int userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final data = await UserService.fetchLoggedUserData();
    setState(() {
      userId = data?['id'];
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return  const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6)));
    }

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: RefreshIndicator(
        onRefresh: AppLoader.handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    DashboardHeader(),
                    const SizedBox(height: 5),
                    DashboardSummary(userId: userId,),
                    const SizedBox(height: 10),
                    DashboardOtherContent(userId: userId,),
                  ],
                ),
              ),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('👔 Employer Dashboard', style: AppText.textXl.merge(AppText.fontSemibold)),
        SizedBox(
          width: double.infinity,
          child: Card(
            color: const Color.fromARGB(255, 255, 236, 200),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text('🔒 Account pending verification.', style: TextStyle(color: Color.fromARGB(255, 203, 152, 0))),
                  GestureDetector(
                    child: Text('Submit Documents', style: const TextStyle(color: Color.fromARGB(255, 130, 98, 0), decoration: TextDecoration.underline).merge(AppText.fontSemibold)),
                    onTap: () {
                      
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DashboardSummary extends StatefulWidget {
  final int userId;
  const DashboardSummary({
    super.key,
    required this.userId
  });
  @override
  _DashboardSummaryState createState() => _DashboardSummaryState();
}
class _DashboardSummaryState extends State<DashboardSummary> {
  int? activeJobCount;
  int applicationCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCounts(widget.userId);
  }

  Future<void> loadCounts(int userId) async {
    final activeJobsCount = await JobService.fetchJobCountByEmployer(userId);
    setState(() {
      activeJobCount = activeJobsCount;
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(padding: EdgeInsets.only(top: 50),child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6));
    }
    
    return Column(
      children: [
        DashboardSummaryCard(header: '💼 Active Jobs', count: activeJobCount == null ? '...' : activeJobCount.toString(), color: AppColor.success),
        DashboardSummaryCard(header: '👥 Applications', count: 5.toString(), color: AppColor.primary),
        const DashboardSummaryCard(header: '📊 Trends', count: 'Coming soon...', color: AppColor.info),
      ],
    );
  }
}

class DashboardOtherContent extends StatelessWidget {
  final int userId;

  const DashboardOtherContent({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardOtherContentCard(header: '📢 Post Jobs', paragraph: 'Create new job posts with Lite, Branded, or Premium visibility.', button: PostANewJobButton()),
        const SizedBox(height: 10),
        DashboardOtherContentCard(header: '📄 Manage Applications', paragraph: 'View, filter, and track candidate applications.', button: EmployerContentCardButton(text: 'View Applications', page: ViewApplications(onNavigate: (page) => globalNavigateTo?.call(page), userId: userId))),
        const SizedBox(height: 10),
        DashboardOtherContentCard(header: '💬 Communication', paragraph: 'Message applicants directly and receive email notifications', button: EmployerContentCardButton(text: 'Open Messages', page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page)))),
        const SizedBox(height: 10),
        DashboardOtherContentCard(header: '🤝 PESO Assistance', paragraph: 'Request help for job fairs or shortlisting.', button: EmployerContentCardButton(text: 'Request Help', page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page)))),
        const SizedBox(height: 10),
        DashboardOtherContentCard(header: '🔔 Recent Notifications', paragraph: 'No notifications yet.', button: EmployerContentCardButton(text: 'View Norifications', page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page)))),
        const SizedBox(height: 10),
        DashboardOtherContentCard(header: '⚖️ Compliance', paragraph: 'View templates and stay updated with labor laws.', button: EmployerContentCardButton(text: 'Go to Compliance Section', page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page)))),
      ],
    );
  }
}