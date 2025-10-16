import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/features/dashboard/admin.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/features/shared/announcements.dart';
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
      { "name": "Announcements", "href": const Announcements() },
      { "name": "Career Hub", "href": claims['role'] == 'job_seeker' ?
          const JobSeekerDashboard() : claims['role'] == 'employer' ?
          const EmployerDashboard() : const AdminDashboard() 
      },
      { "name": "Contact", "href": claims['role'] == 'job_seeker' ?
          const JobSeekerDashboard() : claims['role'] == 'employer' ?
          const EmployerDashboard() : const AdminDashboard()  
      },
    ];

    void logout() async {
      AuthService.logout(context);
    }

    return Drawer(
      width: screenWidth * 0.7,
      child: Container(
        margin: EdgeInsets.only(top: screenHeight * 0.2),
        child: Column(
          children: [
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