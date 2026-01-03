import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const scrollableTablePadding = 24.0;

String formatDateTime(String isoString) {
  final dateTime = DateTime.parse(isoString); 
  final dateFormat = DateFormat("MMMM d, y 'at' h:mm a"); 
  return dateFormat.format(dateTime.toLocal()); // convert to local timezone
}

String formatDateOnly(String isoString) {
  final dateTime = DateTime.parse(isoString); 
  final dateFormat = DateFormat("MMMM d, y"); 
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

String formatToPeso(num amount) {
  final formatter = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 2,
  );

  return formatter.format(amount);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : this;
}

class PdfExporter {
  /// ------------------------------------------------------------
  /// 🔹 GENERIC TABLE EXPORTER
  /// Can export ANY table by passing:
  /// - title = "My Report Title"
  /// - headers = ["Col1", "Col2", ...]
  /// - data = List<List<String>> rows
  /// ------------------------------------------------------------
  static Future<void> exportTable({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Title
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 20),

              // Table
              pw.Table.fromTextArray(
                headers: headers,
                data: rows,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE0E0E0)),
                cellAlignment: pw.Alignment.centerLeft,
                border: pw.TableBorder.all(width: 1),
              ),
            ],
          );
        },
      ),
    );

    // Open PDF preview
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  /// ------------------------------------------------------------
  /// 🔹 Shortcut for converting List<Map<String, dynamic>>
  ///    into List<List<String>> for the table rows.
  /// ------------------------------------------------------------
  static List<List<String>> mapToRowList({
    required List<Map<String, dynamic>> data,
    required List<String> keys,
  }) {
    return data.map((row) {
      return keys.map((key) {
        final value = row[key];

        if (value == null) return "N/A";

        // Convert DateTime objects to readable string
        if (value is DateTime) {
          return value.toIso8601String();
        }

        // Convert List to comma-separated string
        if (value is List) {
          return value.map((e) => e.toString()).join(", ");
        }

        // Convert Map to readable string
        if (value is Map) {
          return value.values.map((e) => e.toString()).join(", ");
        }

        return value.toString();
      }).toList();
    }).toList();
  }

}