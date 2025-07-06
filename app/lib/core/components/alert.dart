import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

void showAlertError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(message, style: AppText.textMd.merge(AppText.fontSemibold).merge(AppText.textDanger)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close alert
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

void showAlertDelete(BuildContext context, String message, int jobId, Future<void> Function(int) onPressed) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(message, style: AppText.textMd.merge(AppText.fontSemibold).merge(AppText.textDark)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close alert
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () => onPressed(jobId), // Close alert
            child: const Text("Yes, I'm sure."),
          ),
        ],
      );
    },
  );
}
