import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/card.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/admin/view_employer_documents.dart';
import 'package:app/features/employer/post_job_form.dart';
import 'package:app/features/employer/view_active_jobs.dart';
import 'package:app/features/employer/view_applications.dart';
import 'package:app/features/shared/conversations.dart';
import 'package:app/features/shared/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmployerDashboard extends HookWidget {
  const EmployerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final userId = claims['id'];

    final loading = useState(true);
    final jobs = useState<List<Map<String, dynamic>>>([]);
    final applications = useState<List<Map<String, dynamic>>>([]);
    final employerVerification = useState<Map<String, dynamic>>({});

    /* ---------------- FETCH VERIFICATION ---------------- */
    useEffect(() {
      if (userId == null) return null;

      () async {
        try {
          employerVerification.value =
              await VerificationService.getVerificationByUser(userId);
        } catch (_) {
          if (!context.mounted) return;
          showAlertError(
            context,
            "Failed to fetch verification. Please logout and re-login.",
          );
        }
      }();

      return null;
    }, [userId]);

    /* ---------------- FETCH JOBS + APPLICATIONS ---------------- */
    useEffect(() {
      if (userId == null) return null;

      () async {
        loading.value = true;
        try {
          jobs.value = await JobService.getJobsByEmployer(userId);
          applications.value =
              await ApplicationService.getApplicationsByEmployer(userId);
        } catch (_) {
          if (!context.mounted) return;
          showAlertError(
            context,
            "Failed to fetch employer data. Please logout and re-login.",
          );
        } finally {
          loading.value = false;
        }
      }();

      return null;
    }, [userId]);

    /* ---------------- SUBMIT VERIFICATION ---------------- */
    Future<void> submitVerification() async {
      if (userId == null) return;

      try {
        final res = await VerificationService.createVerification({
          'employerId': userId,
          'documents': 'TESTING',
          'status': 'pending',
          'role': 'employer',
        });

        if (res.isNotEmpty && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Document submitted successfully. Please wait for admin review.',
              ),
            ),
          );
        }
      } catch (_) {
        if (!context.mounted) return;
        showAlertError(
          context,
          "Failed to submit verification. Please try again.",
        );
      }
    }

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: loading.value 
        ? const Loader()
        : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  DashboardHeader(
                    employerVerification: employerVerification.value,
                    submitVerification: submitVerification,
                    claims: claims,
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
  final Map<String, dynamic> claims;

  const DashboardHeader({
    super.key,
    required this.submitVerification,
    required this.employerVerification,
    required this.claims,
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
                      onTap: () => navigateTo(context, ViewEmployerDocuments(claims: claims)),
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
          if (employerVerification["status"] == 'rejected' || employerVerification["status"] == 'pending')
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  color: const Color.fromARGB(255, 227, 238, 255),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Verification Status: ${employerVerification['status'].toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: AppText.textMd
                              .merge(AppText.fontSemibold)
                              .copyWith(
                                color: employerVerification['status'] == 'approved'
                                    ? Colors.green
                                    : employerVerification['status'] == 'rejected'
                                        ? AppColor.danger
                                        : AppColor.primary, // pending
                              ),
                        ),

                        // ❌ REJECTED → show reason
                        if (employerVerification['status'] == "rejected") ...[
                          const SizedBox(height: 8),
                          Text(
                            'Reason: ${employerVerification["note"] ?? "Reason not specified."}',
                            textAlign: TextAlign.center,
                            style: AppText.textSm.copyWith(color: Colors.black),
                          ),
                        ],

                        // ✅ PENDING → show button
                        if (employerVerification['status'] == 'pending') ...[
                          const SizedBox(height: 12),
                          AppButton(
                            label: 'View Documents',
                            onPressed: () => navigateTo(
                              context,
                              ViewEmployerDocuments(
                                claims: claims,
                              ),
                            ),
                            visualDensityY: -2,
                          ),
                        ],
                      ],
                    ),
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
          paragraph: '', 
          button: EmployerContentCardButton(text: 'View Notifications', page: Notifications())
        ),
      ],
    );
  }
}