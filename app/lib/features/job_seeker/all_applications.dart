import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/job_seeker/view_application.dart';
import 'package:app/features/shared/messages.dart';
import 'package:flutter/material.dart';
import 'package:app/core/hooks/utils.dart';

class AllApplications extends StatelessWidget {
  final Map<String, dynamic> claims; 
  final List<Map<String, dynamic>> applications;

  const AllApplications({
    super.key,
    required this.claims,
    required this.applications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            const AllApplicationsHeader(),
            const SizedBox(height: 20),
            AllApplicationsTable(
              applications: applications,
              claims: claims,
            )
          ],
        ),
      ),
    );
  }
}

class AllApplicationsHeader extends StatelessWidget {
  const AllApplicationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('All Applications', style: AppText.textXl.merge(AppText.fontSemibold)),
        GestureDetector(
          child: Text('⬅️ Back', style: AppText.textPrimary,),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AllApplicationsTable extends StatelessWidget {
  final Map<String, dynamic> claims;
  final List<Map<String, dynamic>> applications;
  
  const AllApplicationsTable({
    super.key,
    required this.claims,
    required this.applications,
  });
  @override
  Widget build(BuildContext context) {
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
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Company')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Salary')),
              DataColumn(label: Text('Employer')),
              DataColumn(label: Text('Actions')),
            ],
            rows: applications.map((job) {
              return DataRow(
                cells: [
                  DataCell(Text(job['title'] ?? 'N/A')),
                  DataCell(Text(job['company']?.toString() ?? 'N/A')),
                  DataCell(Text(job['location'] ?? 'N/A')),
                  DataCell(Text(formatToPeso(job['salary'] ))),
                  DataCell(Text(job['full_name'] ?? 'N/A')),
                  DataCell(
                    Row(
                      children: [
                        AppButton(
                          label: 'View', 
                          onPressed: () => navigateTo(context, ViewApplication(application: job)),
                          foregroundColor: AppColor.light,
                          visualDensityY: -3,
                          textSize: 12,
                        ),
                        const SizedBox(width: 10),
                        AppButton(
                          label: 'Message', 
                          onPressed: () => navigateTo(context, Messages(user: claims, otherUserId: job['employer_id'])),
                          backgroundColor: AppColor.success,
                          foregroundColor: AppColor.light,
                          visualDensityY: -3,
                          textSize: 12,
                        )
                      ],
                    )
                  ),
                ],
              );
            }).toList()
          ),
        )
      ),
    );
  }
}