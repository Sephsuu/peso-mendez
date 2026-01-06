import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/job_seeker/view_saved_jobs.dart';
import 'package:app/features/shared/job_listing.dart';
import 'package:app/features/job_seeker/all_applications.dart';
import 'package:app/features/job_seeker/edit_profile.dart';
import 'package:app/features/job_seeker/view_application.dart';
import 'package:app/features/job_seeker/view_job.dart';
import 'package:app/features/shared/messages.dart';
import 'package:app/features/shared/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class JobSeekerDashboard extends HookWidget {
  const JobSeekerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (ctx) => Scaffold.of(ctx).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              DashboardHeader(fullName: claims["full_name"] ?? "..."),
              const SizedBox(height: 10),
              ProfileStrengthCard(claims: claims),
              const SizedBox(height: 10),
              NotificationsCard(claims: claims),
              const SizedBox(height: 10),
              YourApplicationsCard(claims: claims),
              const SizedBox(height: 10),
              SavedJobsCard(claims: claims),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final String fullName; 

  const DashboardHeader({
    super.key,
    required this.fullName,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        "Welcome Back!\n$fullName",
        style: AppText.textXl.merge(AppText.fontBold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ProfileStrengthCard extends HookWidget {
  final Map<String, dynamic> claims;
  const ProfileStrengthCard({
    super.key,
    required this.claims,
  });

  @override
  Widget build(BuildContext context) {
    final userId = claims['id'];
    final loading = useState(true);
    final strength = useState<double>(0);

    useEffect(() {
      if (userId == null) return null;

      () async {
        try {
          strength.value =
              await UserService.getUserProfileStrength(userId);
        } catch (_) {
          // silent fail (optional)
        } finally {
          loading.value = false;
        }
      }();

      return null;
    }, [userId]);

    return SizedBox(
      width: double.infinity,
      child: loading.value
        ? const Loader()
        : Card(
        color: Colors.white,
        child: strength.value == 0 
          ? const Loader()
          : Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 234, 234, 234),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Profile Strength'),
                    Text("${(strength.value * 100 / 10).round() * 10}%")
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4), // your desired radius
                child: LinearProgressIndicator(
                  value: strength.value,
                  backgroundColor: Colors.grey[300],
                  color: AppColor.primary,
                  minHeight: 18,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('To complete your profile, please list your skills, upload your resume.', style: AppText.textMuted.merge(AppText.textXs)),
            ),
            const SizedBox(height: 10.0),
            AppButton(
              label: 'Edit Profile', 
              onPressed: () => navigateTo(context, const EditProfile()),
              foregroundColor: AppColor.light,
              textSize: 12,
              visualDensityY: -2,
            ),
            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}

class NotificationsCard extends HookWidget {
  final Map<String, dynamic> claims;
  const NotificationsCard({
    super.key,
    required this.claims,
  });

  @override
  Widget build(BuildContext context) {
    final userId = claims['id'];
    final loading = useState(true);
    final notifications = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      if (userId == null) return null;

      () async {
        try {
          notifications.value =
              await NotificationService.getRecentNotifications(userId);
        } catch (_) {}
        finally {
          loading.value = false;
        }
      }();

      return null;
    }, [userId]);

    if (loading.value) {
      return const Loader();
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 234, 234),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notifications'),
                  GestureDetector(
                    child: Text(
                      'See All',
                      style: AppText.textXs.merge(AppText.textPrimary),
                    ),
                    onTap: () => navigateTo(context, const Notifications()),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            // IF NO NOTIFICATIONS
            if (notifications.value.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'No new notifications.',
                  style: AppText.textMuted.merge(AppText.textXs),
                ),
              ),

            // IF THERE ARE NOTIFICATIONS — DISPLAY THEM
            if (notifications.value.isNotEmpty)
              Column(
                children: notifications.value.map((notif) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 6.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 245, 245),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(255, 210, 210, 210),
                          width: 1,
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notif["type"] ?? "Notification",
                              style: AppText.textXs.merge(AppText.fontSemibold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              notif["content"] ?? "",
                              style: AppText.textXs,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatDateTime(notif["created_at"]),
                              style: AppText.textXs.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class YourApplicationsCard extends HookWidget {
  final Map<String, dynamic> claims;
  const YourApplicationsCard({
    super.key,
    required this.claims
  });

  @override
  Widget build(BuildContext context) {
    final userId = claims['id'];
    final loading = useState(true);
    final apps = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      if (userId == null) return null;

      () async {
        try {
          apps.value =
              await ApplicationService.getApplicationsByUser(userId);
        } catch (_) {}
        finally {
          loading.value = false;
        }
      }();

      return null;
    }, [userId]);

    return SizedBox(
      width: double.infinity,
      child: loading.value
        ? const Loader()
        : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Applications', style: AppText.textLg.merge(AppText.fontSemibold)),
              GestureDetector(
                child: Text('See All', style: AppText.textSm.merge(AppText.textPrimary)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllApplications(
                        applications: apps.value,
                        claims: claims,
                      )
                    ),
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 5.0),
          apps.value.isEmpty ?
            SizedBox(
              width: double.infinity,
              child: Card(
                color: const Color.fromARGB(255, 227, 238, 255),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text("You haven't applied to any jobs yet.\nStart applying to jobs from the job listings page!", style: AppText.textPrimary),
                      const SizedBox(height: 10.0),
                      AppButton(
                        label: 'Browse Jobs', 
                        onPressed: () => navigateTo(context, const JobListing()),
                        foregroundColor: AppColor.light,
                        textSize: 12,
                        visualDensityY: -2,
                      ),
                    ],
                  )
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
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 215, 215, 215)),
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
                    DataColumn(label: Text('Job Title')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: apps.value.take(5).map((application) {
                    return DataRow(
                      cells: [
                        DataCell(Text(application['title'] ?? 'N/A')),
                        DataCell(Text(application['applicationStatus'] ?? 'N/A')),
                        DataCell(
                          Row(
                            children: [
                              AppButton(
                                label: 'View', 
                                onPressed: () => navigateTo(context, ViewApplication(application: application)),
                                foregroundColor: AppColor.light,
                                visualDensityY: -3,
                                textSize: 12,
                              ),
                              const SizedBox(width: 10), 
                              AppButton(
                                label: 'Message', 
                                onPressed: () => navigateTo(context, Messages(user: claims, otherUserId: application['employer_id'])),
                                backgroundColor: AppColor.success,
                                foregroundColor: AppColor.light,
                                visualDensityY: -3,
                                textSize: 12,
                              )
                            ],
                          )
                        ),
                      ],
                    );
                  }).toList()
                ),
              )
            ),
          )
        ],
      )
    );
  }
}

class SavedJobsCard extends HookWidget {
  final Map<String, dynamic> claims;
  const SavedJobsCard({
    super.key,
    required this.claims
  });

  @override
  Widget build(BuildContext context) {
    final userId = claims['id'];
    final loading = useState(true);
    final jobs = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      if (userId == null) return null;

      () async {
        try {
          jobs.value =
              await JobService.getSavedJobsByUser(userId);
        } catch (_) {}
        finally {
          loading.value = false;
        }
      }();

      return null;
    }, [userId]);

    if (loading.value) {
      return const Loader();
    }

    return SizedBox(
      width: double.infinity,
      child: loading.value 
        ? const Loader()
        : Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Saved Jobs', style: AppText.textLg.merge(AppText.fontSemibold)),
              GestureDetector(
                child: Text('See All', style: AppText.textSm.merge(AppText.textPrimary)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedJobsPage(
                        savedJobs: jobs.value,
                        claims: claims,
                      )
                    ),
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 5.0),
          jobs.value.isEmpty ?
            SizedBox(
              width: double.infinity,
              child: Card(
                color: const Color.fromARGB(255, 227, 238, 255),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text("You haven't saved any jobs yet.\nSave jobs to review them later!", style: AppText.textPrimary),
                      const SizedBox(height: 10.0),
                      AppButton(
                        label: 'Browse Jobs', 
                        onPressed: () => navigateTo(context, const JobListing()),
                        foregroundColor: AppColor.light,
                        textSize: 12,
                        visualDensityY: -2,
                      ),
                    ],
                  )
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
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 215, 215, 215)),
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
                    DataColumn(label: Text('Job Title')),
                    DataColumn(label: Text('Salary')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: jobs.value.take(5).map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item['title'] ?? 'N/A')),
                        DataCell(Text(formatToPeso(item['salary']))),
                        DataCell(
                          Row(
                            children: [
                              AppButton(
                                label: 'View', 
                                onPressed: () => navigateTo(context, ViewJob(jobId: item['id'])),
                                foregroundColor: AppColor.light,
                                visualDensityY: -3,
                                textSize: 12,
                              ),
                              const SizedBox(width: 10), 
                              AppButton(
                                label: 'Message', 
                                onPressed: () => navigateTo(context, Messages(user: claims, otherUserId: item['employer_id'])),
                                backgroundColor: AppColor.success,
                                foregroundColor: AppColor.light,
                                visualDensityY: -3,
                                textSize: 12,
                              )
                            ],
                          )
                        ),
                      ],
                    );
                  }).toList()
                ),
              )
            ),
          )
        ],
      )
    );
  }
}