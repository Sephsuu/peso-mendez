import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/homepage.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class EmployerDashboard extends StatelessWidget {
  final Function(PageType) onNavigate;

  const EmployerDashboard({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
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
                    DashboardSummary(activeJobsCount: 5, applicationCount: 5),
                    const SizedBox(height: 10),
                    DashboardOtherContent(),
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
                  Text('🔒 Account pending verification.', style: TextStyle(color: const Color.fromARGB(255, 203, 152, 0))),
                  GestureDetector(
                    child: Text('Submit Documents', style: TextStyle(color: const Color.fromARGB(255, 130, 98, 0), decoration: TextDecoration.underline).merge(AppText.fontSemibold)),
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
  final int activeJobsCount;
  final int applicationCount;
  const DashboardSummary({
    super.key,
    required this.activeJobsCount,
    required this.applicationCount
  });
  @override
  _DashboardSummaryState createState() => _DashboardSummaryState();
}
class _DashboardSummaryState extends State<DashboardSummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardSummaryCard(header: '💼 Active Jobs', count: 5.toString(), color: AppColor.success),
        DashboardSummaryCard(header: '👥 Applications', count: 5.toString(), color: AppColor.primary),
        DashboardSummaryCard(header: '📊 Trends', count: 'Coming soon...', color: AppColor.info),
      ],
    );
  }
}

class DashboardOtherContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardOtherContentCard(header: '📢 Post Jobs', paragraph: 'Create new job posts with Lite, Branded, or Premium visibility.', button: PostANewJobButton()),
        const SizedBox(height: 10),
        DashboardOtherContentCard(header: '📄 Manage Applications', paragraph: 'View, filter, and track candidate applications.', button: EmployerContentCardButton(text: 'View Applications', page: Homepage(onNavigate: (page) => globalNavigateTo?.call(page)))),
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