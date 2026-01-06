import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/features/dashboard/admin.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/features/employer/view_active_jobs.dart';
import 'package:app/features/employer/view_employer_profile.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/features/job_seeker/edit_profile.dart';
import 'package:app/features/shared/about.dart';
import 'package:app/features/shared/contact.dart';
import 'package:app/features/shared/conversations.dart';
import 'package:app/features/shared/job_listing.dart';
import 'package:app/features/shared/announcements.dart';
import 'package:app/features/shared/notifications.dart';
import 'package:flutter/material.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OffcanvasNavigation extends HookWidget {  
  const OffcanvasNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final claims = useClaimsHook(context);

    List<Map<String, dynamic>> routes = [
      { 
        "name": "Home", "href": claims['role'] == 'job_seeker' ?
          const JobSeekerDashboard() : claims['role'] == 'employer' ?
          const EmployerDashboard() : const AdminDashboard() 
      },
      { 
        "name": "Profile", "href": claims['role'] == 'job_seeker' ?
          const EditProfile() : claims['role'] == 'employer' ?
          EmployerInformation(claims: claims,) : null 
      },
      { "name": "About", "href": const About() },
      { "name": "Job Listing", "href": claims["role"] != "employer" ? const JobListing() : const ViewActiveJobs() },
      { "name": "Messages", "href": const Conversations() },
      { "name": "Announcements", "href": const Announcements() },
      { "name": "Notifications", "href": const Notifications() },
      { "name": "Contact", "href": const Contact() },

    ];

    void logout() async {
      AuthService.logout(context);
    }

    return Drawer(
      width: screenWidth * 0.7,
      child: claims.isEmpty 
        ? const Loader()
        : Container(
        margin: EdgeInsets.only(top: screenHeight * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/images/peso-mendez.png', width: 80)),
            const SizedBox(height: 30),
            ...routes.expand((item) => [
              GestureDetector(
                child: Text(item["name"], style: AppText.textMd.merge(AppText.fontSemibold)),
                onTap: () => navigateTo(context, item["href"]),
              ),
              const SizedBox(height: 20),
            ]),
            AppButton(
              label: claims.isNotEmpty ? 'Logout' : 'Sign In Now', 
              foregroundColor: AppColor.light,
              backgroundColor: claims.isNotEmpty ? AppColor.danger : AppColor.primary,
              visualDensityY: -2,
              onPressed: claims.isNotEmpty ? () => logout() : () => navigateTo(context, const Login())
            )
          ],
        ),
      )
    );
  }
}