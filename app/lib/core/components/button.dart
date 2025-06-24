import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard.dart/job_seeker.dart';
import 'package:app/features/register.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

import 'package:app/core/theme/colors.dart';

class HomepageFindButton extends StatelessWidget {
  const HomepageFindButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        print("Pressed");
      }, 
      child: const Text('Find Job'),
    );
  }
}

class HomepageRegisterButton extends StatelessWidget {
  const HomepageRegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => JobSeekerDashboard(onNavigate: (page) => globalNavigateTo?.call(page))));
      }, 
      child: const Text('Register Now'),
    );
  }
}

class FeaturedJobsButton extends StatelessWidget {
  const FeaturedJobsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        print("Pressed");
      }, 
      child: const Text('View Details'),
    );
  }
}

class SignInOrRegisterButton extends StatelessWidget {
  const SignInOrRegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Register(onNavigate: (page) => globalNavigateTo?.call(page))));
      }, 
      child: const Text('Sign In/Register')
    );
  }
}

class RegisterNextButton extends StatelessWidget {
  final VoidCallback registerUser;

  const RegisterNextButton({
    super.key,
    required this.registerUser
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
          )
        ),
        onPressed: registerUser, 
        child: const Text('Next'),
      )
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
          )
        ),
        onPressed: () {
          print("Register");
        }, 
        child: const Text('Sign In'),
      )
    );
  }
}

class EditProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {

      }, 
      child: Text('Edit Profile', style: AppText.textXs)
    );
  }
}

class GoToMessagesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {

      }, 
      child: Text('Go to Messages', style: AppText.textXs)
    );
  }
}

class BrowseJobsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {

      }, 
      child: Text('Browse Jobs', style: AppText.textXs)
    );
  }
}