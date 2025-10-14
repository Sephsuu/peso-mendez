import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/employer/employer_upload_document.dart';
import 'package:app/features/employer/view_active_jobs.dart';
import 'package:app/features/employer/view_applications.dart';
import 'package:app/features/homepage.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmployerDashboard extends HookWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useState<Map<String, dynamic>>({});
    // final refresh = useState<bool>(false);
    final jobs = useState<List<Map<String, dynamic>>>([]);
    final applications = useState<List<Map<String, dynamic>>>([]);

    // Future<void> setRefresh() async {
    //   refresh.value = !refresh.value;
    //   // await Future.delayed(const Duration(milliseconds: 300));
    // }

    // Fetch use token and define claims of logged user
    useEffect(() {
      void fetchData() async {
        try {
          final data = await AuthService.getClaims();
          claims.value = data;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to fetch user credential please logout and re-login.");
        }
      }
      fetchData();
      return null;
    }, []);

    // Fetch jobs and existion application for the jobs created by logged employer
    useEffect(() {
      void fetchData() async {
        try {
          final jobsRes = await JobService.getJobsByEmployer(claims.value["id"]);
          final applicationsRes = await ApplicationService.getApplicationsByEmployer(claims.value["id"]);
          jobs.value = jobsRes;
          applications.value = applicationsRes;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to fetch user credential please logout and re-login.");
        }
      }
      fetchData();
      return null;
    }, [claims.value["id"]]);

    // Function for submitting application for employer
    Future<void> submitVerification() async {
      try {
        final res = await VerificationService.createVerification({
          'employerId': claims.value['id'],
          'documents': 'TESTING',
          'status': 'pending',
          'role': 'employer'
        });
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Document application successful. Please wait for admin respons.')),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        showAlertError(context, "Failed to fetch user credential please logout and re-login.");
      }
    }

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  DashboardHeader(submitVerification: submitVerification),
                  const SizedBox(height: 5),
                  DashboardSummary(claims: claims.value, jobs: jobs.value, applications: applications.value),
                  const SizedBox(height: 10),
                  DashboardOtherContent(claims: claims.value, applications: applications.value),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final VoidCallback submitVerification;

  const DashboardHeader({
    super.key,
    required this.submitVerification,
  });

  
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
                    onTap: () => navigateTo(context, const EmpployerUploadDocument()),
                    child: Text('Submit Documents', style: const TextStyle(color: Color.fromARGB(255, 130, 98, 0), decoration: TextDecoration.underline).merge(AppText.fontSemibold)),
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

class DashboardSummary extends StatelessWidget {
  final Map<String, dynamic> claims;
  final List<Map<String, dynamic>> jobs;
  final List<Map<String, dynamic>> applications;

  const DashboardSummary({
    super.key,
    required this.claims,
    required this.jobs,
    required this.applications,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardSummaryCard(
          header: '💼 Active Jobs', 
          count: jobs.length.toString(), 
          color: AppColor.success, 
          onTap: ViewActiveJobs(onNavigate: (page) => globalNavigateTo?.call(page), jobs: jobs,)
        ),
        DashboardSummaryCard(
          header: '👥 Applications', 
          count: applications.length.toString(), 
          color: AppColor.primary, 
          onTap: ViewApplications(applications: applications)
        ),
        const DashboardSummaryCard(
          header: '📊 Trends', 
          count: 'Coming soon...', 
          color: AppColor.info, 
          onTap: Homepage()),
      ],
    );
  }
}

class DashboardOtherContent extends StatelessWidget {
  final Map<String, dynamic> claims;
  final List<Map<String, dynamic>> applications;

  const DashboardOtherContent({
    super.key,
    required this.claims,
    required this.applications,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardOtherContentCard(
          header: '📢 Post Jobs', 
          paragraph: 'Create new job posts with Lite, Branded, or Premium visibility.', 
          button: PostANewJobButton()
        ),
        const SizedBox(height: 10),
        DashboardOtherContentCard(
          header: '📄 Manage Applications', 
          paragraph: 'View, filter, and track candidate applications.', 
          button: EmployerContentCardButton(text: 'View Applications', 
          page: ViewApplications(applications: applications))
        ),
        const SizedBox(height: 10),
        const DashboardOtherContentCard(
          header: '💬 Communication', 
          paragraph: 'Message applicants directly and receive email notifications', 
          button: EmployerContentCardButton(text: 'Open Messages', page: Homepage())
        ),
        const SizedBox(height: 10),
        const DashboardOtherContentCard(
          header: '🤝 PESO Assistance', 
          paragraph: 'Request help for job fairs or shortlisting.', 
          button: EmployerContentCardButton(text: 'Request Help', page: Homepage())),
        const SizedBox(height: 10),
        const DashboardOtherContentCard(
          header: '🔔 Recent Notifications', 
          paragraph: 'No notifications yet.', 
          button: EmployerContentCardButton(text: 'View Norifications', page: Homepage())
        ),
        const SizedBox(height: 10),
        const DashboardOtherContentCard(
          header: '⚖️ Compliance', 
          paragraph: 'View templates and stay updated with labor laws.', 
          button: EmployerContentCardButton(text: 'Go to Compliance Section', page: Homepage())
        ),
      ],
    );
  }
}