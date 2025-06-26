import 'package:app/core/components/modal.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/features/edit_profile.dart';
import 'package:app/features/forms/post_job_form.dart';
import 'package:app/features/homepage.dart';
import 'package:app/features/login.dart';
import 'package:app/features/register.dart';
import 'package:app/features/view_job_detail.dart';
import 'package:app/main.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:app/core/theme/colors.dart';

// HOMEPAGE

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

class HomepageRegisterButton extends StatefulWidget {
  const HomepageRegisterButton({super.key});
  _HomepageRegisterButtonState createState() => _HomepageRegisterButtonState();
}
class _HomepageRegisterButtonState extends State<HomepageRegisterButton> {
  List<Job>? jobs;
  bool _loggedIn = false;
  String? userRole;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    loadUser();
  }

  void checkLoginStatus() async {
    final loggedIn = await UserService.isLoggedIn();
    setState(() {
      _loggedIn = loggedIn;
    });
  }

  void loadUser() async {
    final data = await UserService.fetchLoggedUserData();
    setState(() {
      userRole = data?['role'] ?? "no role";
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_loggedIn ? ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login(onNavigate: (page) => globalNavigateTo?.call(page))));
      }, 
      child: const Text('Sign In Now'),
    ) : ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        if (userRole == 'employer') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployerDashboard(onNavigate: (page) => globalNavigateTo?.call(page))));
        } else if (userRole == 'job_seeker') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => JobSeekerDashboard(onNavigate: (page) => globalNavigateTo?.call(page))));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(userRole ?? 'no token')),
          );
        }
      }, 
      child: const Text('View Profile'),
    );
  }
}

class FeaturedJobsButton extends StatefulWidget {
  final int jobId;
  const FeaturedJobsButton({
    super.key,
    required this.jobId
  });
  @override
  _FeaturedJobsButtonState createState() => _FeaturedJobsButtonState();
}
class _FeaturedJobsButtonState extends State<FeaturedJobsButton> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final loggedIn = await UserService.isLoggedIn();
    setState(() {
      _loggedIn = loggedIn;
    });
  }

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
        if (_loggedIn) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewJobDetail(onNavigate: (page) => globalNavigateTo?.call(page), jobId: widget.jobId,)));
        } else { Navigator.push(context, MaterialPageRoute(builder: (context) => Login(onNavigate: (page) => globalNavigateTo?.call(page)))); }
      }, 
      child: const Text('View Details'),
    );
  }
}

class SignInOrRegisterButton extends StatefulWidget {
  const SignInOrRegisterButton({super.key});
  @override
  _SignInOrRegisterButtonState createState() => _SignInOrRegisterButtonState();
}
class _SignInOrRegisterButtonState extends State<SignInOrRegisterButton> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final loggedIn = await UserService.isLoggedIn();
    setState(() {
      _loggedIn = loggedIn;
    });
  }

  void logout(BuildContext context) async {
    await UserService.deleteToken();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully logged out.')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Login(onNavigate: (page) => globalNavigateTo?.call(page)),
      ),
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return !_loggedIn ? ElevatedButton(
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
    ) : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.danger,
            foregroundColor: AppColor.light,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            )
          ),
          onPressed: () => logout(context), 
          child: const Text('Logout')
        );
  }
}

// REGISTER

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

// LOGIN

class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({super.key, required this.onPressed});

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
        onPressed: onPressed, 
        child: const Text('Sign In'),
      )
    );
  }
}

// JOB SEEKER DASHBOARD

class EditProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(onNavigate: (page) => globalNavigateTo?.call(page))));
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
        visualDensity: const VisualDensity(vertical: -2),
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
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(onNavigate: (page) => globalNavigateTo?.call(page))));
      }, 
      child: Text('Browse Jobs', style: AppText.textXs)
    );
  }
}

// VIEW JOB DETAIL

class ViewJobApplyJobButton extends StatelessWidget {
  final int jobId;
  const ViewJobApplyJobButton({
    super.key, 
    required this .jobId
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
          showJobDetailModal(context, jobId);
      }, 
      child: const Text('Apply')
    );
  }
}

class ViewJobSendMessageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.success,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {

      }, 
      child: const Text('✉️ Message')
    );
  }
}

class ViewJobBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.secondary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.of(context).pop();
      }, 
      child: const Text('Back')
    );
  }
}

// EMPLOYES DASHBOARD

class PostANewJobButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PostNewJob(onNavigate: (page) => globalNavigateTo?.call(page))));
      }, 
      child: Text('Post a New Job', style: AppText.textXs)
    );
  }
}

class EmployerContentCardButton extends StatelessWidget {
  final String text;
  final Widget page;

  const EmployerContentCardButton({
    super.key,
    required this.text,
    required this.page
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.light,
        foregroundColor: AppColor.primary,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(
            color: AppColor.primary, // Border color
            width: 1,              // Border width
            style: BorderStyle.solid // Border style (solid, none)
          ),
        )
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      }, 
      child: Text(text, style: AppText.textXs)
    );
  }
}

// POST NEW JOB

class PostJobButton extends StatelessWidget {
  final VoidCallback onPressed;

  PostJobButton({
    super.key, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.success,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: onPressed, 
      child: const Text('🚀 Post Job')
    );
  }
}

class PostJobBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.secondary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
      onPressed: () {
        Navigator.of(context).pop();
      }, 
      child: const Text('Back')
    );
  }
} 

class SubmitApplicationButton extends StatefulWidget {
  final int jobId;

  const SubmitApplicationButton({
    Key? key,
    required this.jobId,
  }) : super(key: key);

  @override
  _SubmitApplicationButtonState createState() => _SubmitApplicationButtonState();
}
class _SubmitApplicationButtonState extends State<SubmitApplicationButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(vertical: -2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: () {
        showJobDetailModal(context, widget.jobId);
      },
      child: const Text('Submit Application'),
    );
  }
}