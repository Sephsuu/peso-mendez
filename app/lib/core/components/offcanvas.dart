import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';
import 'package:app/features/homepage.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

List<Map<String, dynamic>> routes = [
  { "name": "Home", "href": const Homepage() },
  { "name": "My Profile", "href": const JobSeekerDashboard() },
  { "name": "Job Listing", "href": const Homepage() },
  { "name": "Career Hub", "href": const Homepage() },
  { "name": "Contact", "href": const Homepage() },
];

class OffcanvasNavigation extends HookWidget {  
  const OffcanvasNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final isLoggedIn = useState(false);

    useEffect(() {
      void fetchData() async {
        try {
          final loggedRes = await AuthService.isLoggedIn();
          isLoggedIn.value = loggedRes;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to load jobs.");
        }
      }
      fetchData();
      return null;
    }, []);

    void logout() async {
      AuthService.logout(context);
      isLoggedIn.value = !isLoggedIn.value;
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
              label: isLoggedIn.value ? 'Logout' : 'Sign In Now', 
              foregroundColor: AppColor.light,
              backgroundColor: isLoggedIn.value ? AppColor.danger : AppColor.primary,
              visualDensityY: -2,
              onPressed: isLoggedIn.value ? () => logout() : () => navigateTo(context, const Login())
            )
          ],
        ),
      )
    );
  }
}