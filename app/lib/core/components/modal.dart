import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class AppModal extends StatelessWidget {
  final String title;
  final Object? message;
  final VoidCallback? onConfirm;
  final String? confirmLabel;
  final Color? confirmForeground;
  final Color?  confirmBackground;
  final TextStyle? titleStyle;
  final EdgeInsets? insetPadding;
  final bool hideCloseButton;

  const AppModal({
    super.key,
    required this.title,
    this.message,
    this.onConfirm,
    this.confirmLabel,
    this.confirmForeground = AppColor.dark,
    this.confirmBackground = AppColor.light,
    this.hideCloseButton = false,
    this.titleStyle,
    this.insetPadding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: insetPadding ?? const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(title, style: AppText.textMd.merge(titleStyle).merge(AppText.fontSemibold)),
      content: SizedBox(
        width: double.maxFinite, // take full width
        child: message == null
            ? null
            : (message is String
                ? Text(message as String)
                : message is Widget
                    ? message as Widget
                    : Text(message.toString())),
      ),
      actions: [
        if (!hideCloseButton)
          TextButton(
            onPressed: () => Navigator.pop(context), // closes modal
            child: const Text("Cancel"),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmBackground,
            foregroundColor: confirmForeground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: () {
            Navigator.pop(context); // close modal
            if (onConfirm != null) onConfirm!(); // run callback
          },
          child: Text(confirmLabel ?? 'Confirm')
        )
      ],
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