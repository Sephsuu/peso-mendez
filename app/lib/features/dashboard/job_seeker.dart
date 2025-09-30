import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/homepage.dart';
import 'package:app/features/job_seeker/all_applications.dart';
import 'package:app/features/job_seeker/edit_profile.dart';
import 'package:app/features/job_seeker/view_application.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';


class JobSeekerDashboard extends HookWidget {
  const JobSeekerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useState<Map<String, dynamic>>({});
    final applications = useState<List<Map<String, dynamic>>>([]);

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

    // Fetch applications done by the user
    useEffect(() {
      void fetchData() async {
        try {
          final data = await ApplicationService.getApplicationsByUser(claims.value["id"]);
          applications.value = data;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to fetch applications. Please try again.");
        }
      }
      fetchData();
      return null;
    }, [claims.value["id"]]);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  DashboardHeader(fullName: claims.value["full_name"] ?? "..."),
                  const SizedBox(height: 10.0),
                  const ProfileStrengthCard(),
                  const SizedBox(height: 10.0),
                  const NotificationsCard(),
                  const SizedBox(height: 10.0),
                  const GoToMessagesCard(),
                  const SizedBox(height: 10.0),
                  YourApplicationsCard(applications: applications.value),
                  const SizedBox(height: 15.0),
                  const SuggestedTrainings(),
                  const SizedBox(height: 15.0),
                  const SavedJobsCard(),
                ],
              ),
            ),
            const Footer(),
          ],
        )
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

class ProfileStrengthCard extends StatefulWidget {
  const ProfileStrengthCard({super.key});

  @override
  State<ProfileStrengthCard> createState() => _ProfileStrengthCardState();
}

class _ProfileStrengthCardState extends State<ProfileStrengthCard> {
  double progress = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Column(
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
                    Text("${progress * 100}%")
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
                  value: progress,
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

class NotificationsCard extends StatefulWidget {
  const NotificationsCard({super.key});

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Column(
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
                    const Text('Notifications'),
                    GestureDetector(
                      child: Text('Sea All', style: AppText.textXs.merge(AppText.textPrimary)),
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('No new notifications.', style: AppText.textMuted.merge(AppText.textXs)),
            ),
            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}

class GoToMessagesCard extends StatelessWidget {
  const GoToMessagesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Column(
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
                child: const Text('Messages'),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text('Chat with employers regarding your applications.', style: AppText.textMuted.merge(AppText.textXs)),
            ),
            const SizedBox(height: 10.0),
            AppButton(
              label: 'Go To Messages', 
              onPressed: () => {},
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

class YourApplicationsCard extends HookWidget {
  final List<Map<String, dynamic>> applications;
  const YourApplicationsCard({
    super.key,
    required this.applications,
  });

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return const Loader();
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Applications', style: AppText.textLg.merge(AppText.fontSemibold)),
              GestureDetector(
                child: Text('Sea All', style: AppText.textSm.merge(AppText.textPrimary)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllApplications(applications: applications)
                    ),
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 5.0),
          applications.isEmpty ?
            Card(
              color: const Color.fromARGB(255, 211, 255, 235),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text("You haven't applied to any jobs yet.\nStart applying to jobs from the job listings page!", style: AppText.textSuccess),
                    const SizedBox(height: 10.0),
                    AppButton(
                      label: 'Browse Jobs', 
                      onPressed: () => navigateTo(context, const Homepage()),
                      foregroundColor: AppColor.light,
                      textSize: 12,
                      visualDensityY: -2,
                    ),
                  ],
                )
              ),
            )
          : SingleChildScrollView(
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
                  rows: applications.take(5).map((application) {
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
                                onPressed: () {},
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
            )
        ],
      )
    );
  }
}

class SuggestedTrainings extends StatefulWidget {
  const SuggestedTrainings({super.key});

  @override
  State<SuggestedTrainings> createState() => _SuggestedTrainingsState();
}

class _SuggestedTrainingsState extends State<SuggestedTrainings> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggested Trainings and Events', style: AppText.textLg.merge(AppText.fontSemibold)),
          Text('No upcoming trainings or events', style: AppText.textMuted)
        ],
      ),
    );
  }
}

class SavedJobsCard extends StatefulWidget {
  const SavedJobsCard({super.key});

  @override
  State<SavedJobsCard> createState() => _SavedJobsCardState();
}

class _SavedJobsCardState extends State<SavedJobsCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Saved Jobs', style: AppText.textLg.merge(AppText.fontSemibold)),
              GestureDetector(
                child: Text('Sea All', style: AppText.textXs.merge(AppText.textPrimary)),
                onTap: () {},
              )
            ],
          ),
          const SizedBox(height: 5.0),
          SizedBox(
            width: double.infinity,
            child: Card(
              color: const Color.fromARGB(255, 211, 255, 235),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text("You haven't saved any jobs yet.\nSave jobs to review them later!", style: AppText.textSuccess),
                    const SizedBox(height: 10.0),
                    AppButton(
                      label: 'Browse Jobs', 
                      onPressed: () => navigateTo(context, const Homepage()),
                      foregroundColor: AppColor.light,
                      textSize: 12,
                      visualDensityY: -2,
                    ),
                  ],
                )
              ),
            ),
          )
        ],
      )
    );
  }
}