import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/register.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';


class JobSeekerDashboard extends StatelessWidget {
  final Function(PageType) onNavigate;

  const JobSeekerDashboard({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
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
                  const DashboardHeader(),
                  const SizedBox(height: 10.0),
                  ProfileStrengthCard(),
                  const SizedBox(height: 10.0),
                  const NotificationsCard(),
                  const SizedBox(height: 10.0),
                  const GoToMessagesCard(),
                  const SizedBox(height: 10.0),
                  const YourApplicationsCard(),
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

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  _DashboardHeaderState createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final data = await UserService.fetchLoggedUserData();
    setState(() {
      userName = data?['full_name'] ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        userName == null ? '...' : "Welcome Back!\n$userName",
        style: AppText.textXl.merge(AppText.fontBold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ProfileStrengthCard extends StatefulWidget {
  ProfileStrengthCard({super.key});

  @override
  _ProfileStrengthCardState createState() => _ProfileStrengthCardState();
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
            EditProfileButton(),
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
  _NotificationsCardState createState() => _NotificationsCardState();
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(onNavigate: (page) => globalNavigateTo?.call(page))
                          ),
                        );
                      },
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
            GoToMessagesButton(),
            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}

class YourApplicationsCard extends StatefulWidget {
  const YourApplicationsCard({super.key});

  @override
  _YourApplicationsCardState createState() => _YourApplicationsCardState();
}

class _YourApplicationsCardState extends State<YourApplicationsCard> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your Applications', style: AppText.textLg.merge(AppText.fontSemibold)),
              GestureDetector(
                child: Text('Sea All', style: AppText.textXs.merge(AppText.textPrimary)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(onNavigate: (page) => globalNavigateTo?.call(page))
                    ),
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 5.0),
          Card(
            color: const Color.fromARGB(255, 211, 255, 235),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text("You haven't applied to any jobs yet.\nStart applying to jobs from the job listings page!", style: AppText.textSuccess),
                  const SizedBox(height: 10.0),
                  BrowseJobsButton()
                ],
              )
            ),
          )
        ],
      )
    );
  }
}

class SuggestedTrainings extends StatefulWidget {
  const SuggestedTrainings({super.key});

  @override
  _SuggestedTrainingsState createState() => _SuggestedTrainingsState();
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
  _SavedJobsCardState createState() => _SavedJobsCardState();
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(onNavigate: (page) => globalNavigateTo?.call(page))
                    ),
                  );
                },
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
                    BrowseJobsButton()
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