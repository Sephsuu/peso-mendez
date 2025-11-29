import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:app/core/hooks/utils.dart';

class AllApplications extends StatelessWidget {
  final List<Map<String, dynamic>> applications;

  const AllApplications({
    super.key,
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
            AllApplicationsTable(applications: applications)
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
  final List<Map<String, dynamic>> applications;
  
  const AllApplicationsTable({
    super.key,
    required this.applications,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      GestureDetector(
                        onTap: () {
                          null;
                        },
                        child: Text("View", style: AppText.textPrimary),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => null,
                        child: Text("Message", style: AppText.textSuccess),
                      ),
                    ],
                  )
                ),
              ],
            );
          }).toList()
        ),
      )
    );
  }
}