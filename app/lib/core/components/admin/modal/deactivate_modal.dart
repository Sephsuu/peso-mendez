import 'package:app/core/components/alert.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

void deactivateModal(BuildContext context, Map<String, dynamic> user) {

  void deactivateUser() async {
    try {
      final res = await UserService.deactivateUser(user["id"]);
      if (res.isNotEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User successfully deactivated.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
      if (!context.mounted) return;
    } catch (e) { showAlertError(context, "Error $e"); }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure to deactivate user: ${user["full_name"]}', style: AppText.textMd),
        content: const Text('If deactivated, the user will no longer be able to access this account.'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), 
                child: const Text('Close'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.danger,
                  foregroundColor: AppColor.light,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: deactivateUser, 
                child: const Text("Yes, I'm sure.")
              )
            ],
          )
        ],
      );
    },
  );
}
