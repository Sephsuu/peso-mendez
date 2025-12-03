import 'package:app/core/components/navigation.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/register.dart';
import 'package:flutter/material.dart';
import 'package:app/core/theme/colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final double textSize;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double visualDensityY;
  final bool isDisabled;
  final bool disableShadow; // 👈 NEW
  final VoidCallback? onPressed;
  final Color? shadowColor; // 👈 Now optional

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textSize = 14,
    this.foregroundColor = AppColor.light,
    this.backgroundColor = AppColor.primary,
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.visualDensityY = 0,
    this.isDisabled = false,
    this.disableShadow = false, // 👈 Default: false
    this.shadowColor, // 👈 Optional
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        visualDensity: VisualDensity(vertical: visualDensityY),
        padding: padding,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        elevation: disableShadow ? 0 : 2, // 👈 Removes shadow when true
        shadowColor: disableShadow
            ? Colors.transparent // 👈 No shadow color when disabled
            : (shadowColor ?? Colors.grey.withValues(alpha: 0.5)), // 👈 Default shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: textSize,
        ),
      ),
    );
  }
}

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
      onPressed: () {}, 
      child: const Text('Find Job'),
    );
  }
}

class SignInOrRegisterButton extends StatefulWidget {
  const SignInOrRegisterButton({super.key});
  @override
  State<SignInOrRegisterButton> createState() => _SignInOrRegisterButtonState();
}
class _SignInOrRegisterButtonState extends State<SignInOrRegisterButton> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final loggedIn = await AuthService.isLoggedIn();
    setState(() {
      _loggedIn = loggedIn;
    });
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
      onPressed: () => navigateTo(context, const Register()),
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
          onPressed: () => AuthService.logout(context), 
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

class ViewJobSendMessageButton extends StatelessWidget {
  const ViewJobSendMessageButton({super.key});

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
  const ViewJobBackButton({super.key});

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

// EMPLOYERS DASHBOARD

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

// APPLIED ALREADY

class BackToJobListingButton extends StatelessWidget {
  const BackToJobListingButton({super.key});

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
        // Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage(onNavigate: (page) => globalNavigateTo?.call(page))));
      }, 
      child: Text('Back to Job Listing', style: AppText.textXs)
    );
  }
}

class AppliedAlreadyBackButton extends StatelessWidget {
  const AppliedAlreadyBackButton({super.key});

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

// ADMIN DASHBOARD
class AdminActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final Widget page;

  const AdminActionButton({
    super.key,
    required this.color,
    required this.page,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.light,
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: BorderSide(
              color: color,
            ),
          )
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }, 
        child: Text(text)
      ),
    );
  }
}