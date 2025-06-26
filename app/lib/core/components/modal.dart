import 'package:app/core/components/button.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

Future<void> showJobDetailModal(BuildContext context, int jobId) async {
  showDialog(
    context: context,
    barrierDismissible: false, // prevent dismiss while loading
    builder: (context) => const Center(child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6)),
  );

  try {
    final job = await JobService.fetchJobById(jobId);
    final fetchedEmployer = await UserService.fetchUserById(job.employer_id);

    Navigator.of(context).pop();

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply for ${job.title} at ${job.location}", style: AppText.textXl.merge(AppText.fontSemibold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppText.textDark.copyWith(height: 1.5),
                  children: [
                    TextSpan(text: "You're about to apply for: "),
                    TextSpan(text: job.title, style: AppText.fontSemibold),
                    TextSpan(text: " at  "),
                    TextSpan(text: "${job.location}.", style: AppText.fontSemibold),
                  ]
                ),
              ),
              const SizedBox(height: 15),
              Text('Your profile information will be shared with the employer.')
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SubmitApplicationButton(jobId: job.id),
                const SizedBox(width: 5),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            )
          ],
        );
      },
    );
  } catch (e) {
    // Close loading dialog if still open
    Navigator.of(context).pop();

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load job details: $e')),
    );
  }
}

