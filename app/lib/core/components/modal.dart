import 'package:app/core/components/button.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

// VIEW JOB DETAIL (view_job_detal.dart)
Future<void> showJobDetailModal(BuildContext context, Map<String, dynamic> job, int userId) async {
  showDialog(
    context: context,
    barrierDismissible: false, // prevent dismiss while loading
    builder: (context) => const Center(child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6)),
  );

  try {
    Navigator.of(context).pop();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply for ${job['title']} at ${job['location']}", style: AppText.textXl.merge(AppText.fontSemibold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppText.textDark.copyWith(height: 1.5),
                  children: [
                    const TextSpan(text: "You're about to apply for: "),
                    TextSpan(text: job['title'], style: AppText.fontSemibold),
                    const TextSpan(text: " at  "),
                    TextSpan(text: "${job['location']}.", style: AppText.fontSemibold),
                  ]
                ),
              ),
              const SizedBox(height: 15),
              const Text('Your profile information will be shared with the employer.')
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SubmitApplicationButton(
                  job: job, 
                  userId: userId,
                  onClose: () => Navigator.of(context).pop(), 
                ),
                const SizedBox(width: 5),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            )
          ],
        );
      },
    );
  } catch (e) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load job details: $e')),
    );
  }
}

Future<String?> updateApplicationStatusModal(BuildContext context, String? newValue) async {
  final result = await showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text("Update application status to '$newValue'?"),
      content: const Text("Are you sure you want to change the application status?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(newValue); // Return the new value
          },
          child: const Text("Confirm"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null); // Return null on cancel
          },
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
  
  return result;
}