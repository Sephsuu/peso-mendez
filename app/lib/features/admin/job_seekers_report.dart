import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class JobSeekersReport extends HookWidget {  
  const JobSeekersReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final reload = useState(false);
    final find = useState('');
    final jobSeekers = useState<List<Map<String, dynamic>>>([]);
    final filteredJobSeeker = useState<List<Map<String, dynamic>>>([]);

    void setFind(String newVal) {
      find.value = newVal;
    }    

    useEffect(() {
      void fetchData() async {
        try {
          final res = await UserService.getUserByRole("job_seeker");
          jobSeekers.value = res;
          filteredJobSeeker.value = res;
          loading.value = false;
        } catch (e) { 
          if (!context.mounted) return;
          showAlertError(context, "Error: $e"); 
        }
      }
      fetchData();
      return null;
    }, [reload.value]);

    useEffect(() {
      if (find.value.isEmpty) {
        filteredJobSeeker.value = jobSeekers.value;
      } else {
        filteredJobSeeker.value = jobSeekers.value.where((item) {
          final fullName = item["full_name"]?.toLowerCase() ?? '';
          final email = item["email"]?.toLowerCase() ?? '';
          return fullName.contains(find.value.toLowerCase()) || email.contains(find.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [find.value, jobSeekers.value]);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: loading.value 
        ? const Loader()
        : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Job Seeker Report", style: AppText.textXl.merge(AppText.fontSemibold)),
                  GestureDetector(
                    child: Text('⬅️ Back', style: AppText.textPrimary,),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 16),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: AppText.textXs,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.light,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                      labelText: 'Search for a job seeker',
                      labelStyle: AppText.textSm,
                      border: const OutlineInputBorder()
                    ),
                    onChanged: (value) => setFind(value),
                  ),
                ),
                const SizedBox(width: 5),
                AppButton(
                  label: "Export PDF",
                  onPressed: () async {
                    print("🔍 DEBUG: Starting PDF export...");
                    print("🔍 Filtered job seekers count: ${filteredJobSeeker.value.length}");
                    
                    if (filteredJobSeeker.value.isEmpty) {
                      showAlertError(context, "No job seekers to export.");
                      return;
                    }

                    final normalizedData = filteredJobSeeker.value.map((e) {
                      return {
                        "full_name": (e["full_name"] ?? "").toString(),
                        "email": (e["email"] ?? "").toString(),
                        "username": (e["username"] ?? "").toString(),
                        "contact": (e["contact"] ?? "").toString(),
                        "sex": (e["sex"] ?? "N/A").toString(),
                        "clientele": (e["clientele"] ?? "N/A").toString(),
                        "highest_education": (e["highest_education"] ?? "N/A").toString(),
                        "citmun": (e["citmun"] ?? "N/A").toString(),
                      };
                    }).toList();

                    print("🔍 Normalized data count: ${normalizedData.length}");

                    // Convert to rows
                    final keys = [
                      "full_name",
                      "email",
                      "username",
                      "contact",
                      "sex",
                      "clientele",
                      "highest_education",
                      "citmun",
                    ];

                    final rows = normalizedData.map((row) {
                      return keys.map((key) {
                        final value = row[key];
                        if (value == null) return "N/A";
                        return value.toString();
                      }).toList();
                    }).toList();

                    print("🔍 Rows count: ${rows.length}");

                    if (rows.isEmpty) {
                      showAlertError(context, "No valid job seeker data to export.");
                      return;
                    }

                    // Generate PDF
                    final pdf = pw.Document();
                    final title = "Active Job Seekers Report";
                    final headers = [
                      "Full Name",
                      "Email Address",
                      "Username",
                      "Contact Number",
                      "Sex",
                      "Clientele",
                      "Highest Education",
                      "City/Municipality",
                    ];

                    pdf.addPage(
                      pw.Page(
                        pageFormat: PdfPageFormat.a4.landscape,
                        margin: const pw.EdgeInsets.all(24),
                        build: (pw.Context context) {
                          return pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                title,
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Text(
                                "Generated: ${DateTime.now().toString().split('.')[0]}",
                                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                              ),
                              pw.Text(
                                "Total Records: ${rows.length}",
                                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                              ),
                              pw.SizedBox(height: 20),
                              pw.Table.fromTextArray(
                                headers: headers,
                                data: rows,
                                headerStyle: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 9,
                                ),
                                cellStyle: const pw.TextStyle(fontSize: 8),
                                headerDecoration:
                                    const pw.BoxDecoration(color: PdfColor.fromInt(0xFFE0E0E0)),
                                cellAlignment: pw.Alignment.centerLeft,
                                border: pw.TableBorder.all(width: 1),
                                cellPadding: const pw.EdgeInsets.all(4),
                              ),
                            ],
                          );
                        },
                      ),
                    );

                    // Export PDF with fallback
                    try {
                      print("📄 Attempting to open PDF preview...");
                      await Printing.layoutPdf(
                        onLayout: (format) async => pdf.save(),
                        name: '${title.replaceAll(' ', '_')}.pdf',
                      );
                      print("✅ PDF preview opened successfully");
                    } catch (e) {
                      print("⚠️ Preview failed: $e");
                      print("📁 Trying to save to file...");
                      
                      try {
                        final output = await getTemporaryDirectory();
                        final fileName = '${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
                        final file = File("${output.path}/$fileName");
                        await file.writeAsBytes(await pdf.save());
                        
                        print("💾 PDF saved to: ${file.path}");
                        
                        final result = await OpenFile.open(file.path);
                        print("📂 Open file result: ${result.message}");
                        
                        if (result.type == ResultType.done) {
                          print("✅ PDF opened successfully");
                        } else {
                          throw Exception("Could not open PDF: ${result.message}");
                        }
                      } catch (e2) {
                        print("❌ File save/open failed: $e2");
                        if (context.mounted) {
                          showAlertError(context, "Failed to export PDF: $e2");
                        }
                      }
                    }
                  },
                )
              ],
            ),
            const Divider(thickness: 1, height: 16),
            JobSeekersTable(
              jobSeekers: filteredJobSeeker.value,
              loading: loading.value,
            ),
          ],
        ),
      ),
    );
  }
}

class JobSeekersTable extends StatelessWidget {
  final List<Map<String, dynamic>> jobSeekers;
  final bool loading;

  const JobSeekersTable({
    super.key,
    required this.jobSeekers,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Loader();
    }

    return Scrollbar(
      thumbVisibility: true, 
      thickness: 8,
      radius: const Radius.circular(8),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: scrollableTablePadding),
        scrollDirection: Axis.horizontal,
        child: DataTableTheme(
          data: DataTableThemeData(
            headingRowColor: WidgetStateProperty.all(const Color.fromARGB(255, 215, 215, 215)),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          child: DataTable(
            headingRowHeight: 40,
            dataRowMinHeight: 30,
            dataRowMaxHeight: 40,
            border: TableBorder.all(
              color: const Color.fromARGB(255, 191, 191, 191),
              width: 1,
            ),
            columns: const [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('E-mail Address')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Gender')),
              DataColumn(label: Text('Clientele')),
              DataColumn(label: Text('Highest Education')),
              DataColumn(label: Text('City/Municipality')),
              DataColumn(label: Text('Registered At')),
            ], 
            rows: jobSeekers.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;         

            return DataRow(
              cells: [
                DataCell(Text((index + 1).toString())),  
                DataCell(Text(user["full_name"] ?? 'N/A')),
                DataCell(Text(user["email"] ?? 'N/A')),
                DataCell(Text(user["username"] ?? 'N/A')),
                DataCell(Text(user["contact"] ?? 'N/A')),
                DataCell(Text(user["sex"] ?? 'N/A')),
                DataCell(Text(user["clientele"] ?? 'N/A')),
                DataCell(Text(user["highest_education"] ?? 'N/A')),
                DataCell(Text(user["citmun"] ?? 'N/A')),
                DataCell(Text(formatDateOnly(user["created_at"]))),
              ],
            );
          }).toList(),
          ),
        ),
      ),
    );
  }
}