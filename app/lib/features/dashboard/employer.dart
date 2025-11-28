import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/employer/employer_upload_document.dart';
import 'package:app/features/employer/post_job_form.dart';
import 'package:app/features/employer/view_active_jobs.dart';
import 'package:app/features/employer/view_applications.dart';
import 'package:app/features/shared/conversations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmployerDashboard extends HookWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    // final refresh = useState<bool>(false);
    final jobs = useState<List<Map<String, dynamic>>>([]);
    final applications = useState<List<Map<String, dynamic>>>([]);
    final employerVerification = useState<Map<String, dynamic>>({});

    // Future<void> setRefresh() async {
    //   refresh.value = !refresh.value;
    //   // await Future.delayed(const Duration(milliseconds: 300));
    // }

    // Fetch use token and define claims of logged user
    useEffect(() {
      void fetchData() async {
        try {
          final data = await VerificationService.getVerificationByUser(claims['id']);
          employerVerification.value = data;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to fetch user credential please logout and re-login.");
        }
      }
      fetchData();
      return null;
    }, [claims]);

    // Fetch jobs and existion application for the jobs created by logged employer
    useEffect(() {
      void fetchData() async {
        try {
          final jobsRes = await JobService.getJobsByEmployer(claims["id"]);
          final applicationsRes = await ApplicationService.getApplicationsByEmployer(claims["id"]);
          jobs.value = jobsRes;
          applications.value = applicationsRes;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to fetch user credential please logout and re-login.");
        }
      }
      fetchData();
      return null;
    }, [claims["id"]]);

    // Function for submitting application for employer
    Future<void> submitVerification() async {
      try {
        final res = await VerificationService.createVerification({
          'employerId': claims['id'],
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
                  DashboardHeader(
                    employerVerification: employerVerification.value,
                    submitVerification: submitVerification
                  ),
                  const SizedBox(height: 5),
                  DashboardSummary(claims: claims, jobs: jobs.value, applications: applications.value),
                  const SizedBox(height: 10),
                  DashboardOtherContent(
                    claims: claims, 
                    applications: applications.value,
                    employerVerification: employerVerification.value,
                  ),
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
  final Map<String, dynamic> employerVerification; 

  const DashboardHeader({
    super.key,
    required this.submitVerification,
    required this.employerVerification,
  });

  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Employer Dashboard',
            style: AppText.textXl.merge(AppText.fontSemibold),
          ),
        ),
        const Divider(thickness: 1, height: 16),
        if (employerVerification.isEmpty) 
          SizedBox(
            width: double.infinity,
            child: Card(
              color: const Color.fromARGB(255, 255, 236, 200),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text(
                      '🔒 Account pending verification.',
                      style: TextStyle(color: Color.fromARGB(255, 203, 152, 0)),
                    ),
                    GestureDetector(
                      onTap: () => navigateTo(context, const EmployerUploadAllDocuments()),
                      child: Text(
                        'Submit Documents',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 130, 98, 0),
                          decoration: TextDecoration.underline,
                        ).merge(AppText.fontSemibold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Verification Status: ${employerVerification['status'].toUpperCase()}',
              style: AppText.textMd.merge(AppText.fontSemibold),
            ),
          ),
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
          count: jobs.where((job) => job["status"] == "active").length.toString(),
          color: AppColor.success, 
          onTap: const ViewActiveJobs()
        ),
        DashboardSummaryCard(
          header: '👥 Applications', 
          count: applications.length.toString(), 
          color: AppColor.primary, 
          onTap: const ViewApplications()
        ),
      ],
    );
  }
}

class DashboardOtherContent extends StatelessWidget {
  final Map<String, dynamic> claims;
  final List<Map<String, dynamic>> applications;
  final Map<String, dynamic> employerVerification;

  const DashboardOtherContent({
    super.key,
    required this.claims,
    required this.applications,
    required this.employerVerification,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardOtherContentCard(
          header: '📢 Post Jobs', 
          paragraph: 'Advertise your open roles and instantly connect with job seekers.', 
          button: AppButton(
            label: 'Post New Job', 
            visualDensityY: -2,
            textSize: 12,
            onPressed: () {
              if (employerVerification.isNotEmpty && employerVerification['status'] == 'approved') {
                navigateTo(context, const PostNewJob());
              } else {
                showDialog(
                  context: context, 
                  builder: (context) {
                    return const AppModal(
                      title: 'You are not validated as an employer.',
                      message: 'Submit your documents first and wait for the admin to validate your account',
                      confirmLabel: 'I understand',
                      confirmForeground: AppColor.light,
                      confirmBackground: AppColor.primary,
                    );
                  }
                );
              }
            }
          )
        ),
        const SizedBox(height: 10),
        const DashboardOtherContentCard(
          header: '📄 Manage Applications', 
          paragraph: 'View, filter, and track candidate applications.', 
          button: EmployerContentCardButton(text: 'View Applications', 
          page: ViewApplications())
        ),
        const SizedBox(height: 10),
        const DashboardOtherContentCard(
          header: '💬 Communication', 
          paragraph: 'Message applicants directly and receive email notifications', 
          button: EmployerContentCardButton(text: 'Open Messages', page: Conversations())
        ),
        // const SizedBox(height: 10),
        // const DashboardOtherContentCard(
        //   header: '🤝 PESO Assistance', 
        //   paragraph: 'Request help for job fairs or shortlisting.', 
        //   button: EmployerContentCardButton(text: 'Request Help', page: EmployerDashboard())),
        const SizedBox(height: 10),
        const DashboardOtherContentCard(
          header: '🔔 Recent Notifications', 
          paragraph: 'No notifications yet.', 
          button: EmployerContentCardButton(text: 'View Norifications', page: EmployerDashboard())
        ),
        // const SizedBox(height: 10),
        // const DashboardOtherContentCard(
        //   header: '⚖️ Compliance', 
        //   paragraph: 'View templates and stay updated with labor laws.', 
        //   button: EmployerContentCardButton(text: 'Go to Compliance Section', page: EmployerDashboard())
        // ),
      ],
    );
  }
}