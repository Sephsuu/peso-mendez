import 'package:intl/intl.dart';

String formatDateTime(String isoString) {
  final dateTime = DateTime.parse(isoString); 
  final dateFormat = DateFormat("MMMM d, y 'at' h:mm a"); 
  return dateFormat.format(dateTime.toLocal()); // convert to local timezone
}

String formatAnnouncementDate(String dateString) {
  final date = DateTime.parse(dateString);
  final now = DateTime.now();

  // Helper: format time as 3:00 PM
  final timeFormatter = DateFormat('h:mm a');
  String formatTime(DateTime d) => timeFormatter.format(d);

  // Normalize for comparison (strip time)
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final weekAgo = today.subtract(const Duration(days: 7));
  final target = DateTime(date.year, date.month, date.day);

  if (target == today) {
    return 'Today at ${formatTime(date)}';
  } else if (target == yesterday) {
    return 'Yesterday at ${formatTime(date)}';
  } else if (target.isAfter(weekAgo)) {
    // Within the last 7 days
    final weekday = DateFormat('EEE').format(date); // Mon, Tue, etc.
    return '$weekday at ${formatTime(date)}';
  } else {
    // Fallback: Short month name (e.g. Sep 23, 2025 at 7:55 PM)
    final shortDate = DateFormat('MMM d, y').format(date);
    return '$shortDate at ${formatTime(date)}';
  }
}