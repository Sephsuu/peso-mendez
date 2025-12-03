import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChangePassword extends HookWidget {
  final int userId;
  const ChangePassword({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final user = useState<Map<String, dynamic>>({ 
      "userId": userId,
      "old_password": '', 
      "new_password": '',
      "confirm_password": ''
    });

    Future<void> handleSubmit() async {
      try {
        if (user.value["old_password"]!.isEmpty || user.value["new_password"]!.isEmpty || user.value["confirm_password"]!.isEmpty) {
          return AppSnackbar.show(
            context,
            message: "Please fill up all fields.",
            backgroundColor: AppColor.danger,
          );
        }

        if (user.value["confirm_password"] != user.value["new_password"]) {
          return AppSnackbar.show(
            context,
            message: "Password do not matches.",
            backgroundColor: AppColor.danger,
          );
        }

        final data = await AuthService.changePassword(user.value);
        if (data.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "Password changed successfully. Login with your new credential to procees.",
            backgroundColor: AppColor.success,
          );
          await AuthService.logout(context);
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: "$e",
          backgroundColor: AppColor.danger
        );
      }
    }

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Change Password',
                style: AppText.textLg.merge(AppText.fontSemibold),
              ),
            ),
            const Divider(thickness: 1, height: 16),
            const SizedBox(height: 15),
            AppInputField(
              label: 'Old Password',
              visualDensityY: 0,
              obscureText: true,
              onChanged: (value) {
                user.value = {
                  ...user.value,
                  'old_password': value
                };
              },
            ),
            const SizedBox(height: 10),
            AppInputField(
              label: 'New Password',
              visualDensityY: 0,
              obscureText: true,
              onChanged: (value) {
                user.value = {
                  ...user.value,
                  'new_password': value
                };
              },
            ),
            const SizedBox(height: 10),
            AppInputField(
              label: 'Confirm Password',
              visualDensityY: 0,
              obscureText: true,
              onChanged: (value) {
                user.value = {
                  ...user.value,
                  'confirm_password': value
                };
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                AppButton(
                  label: 'Back', 
                  onPressed: () => Navigator.pop(context),
                  visualDensityY: -1,
                  backgroundColor: AppColor.secondary,
                ),
                const SizedBox(width: 10),
                AppButton(
                  label: 'Change Password', 
                  onPressed: () => handleSubmit(),
                  visualDensityY: -1,
                  backgroundColor: AppColor.primary,
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}