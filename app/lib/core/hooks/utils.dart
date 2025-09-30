import 'package:intl/intl.dart';

String formatDateTime(String isoString) {
  final dateTime = DateTime.parse(isoString); 
  final dateFormat = DateFormat("MMMM d, y 'at' h:mm a"); 
  return dateFormat.format(dateTime.toLocal()); // convert to local timezone
}