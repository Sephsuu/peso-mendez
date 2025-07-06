import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class AllApplications extends StatelessWidget {
  final Function(PageType) onNavigate;
  final List<Map<String, dynamic>> applications;

  const AllApplications({
    super.key,
     required this.onNavigate,
     required this.applications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            AllApplicationsHeader(),
            const SizedBox(height: 20),
            AllApplicationsTable(applications: applications)
          ],
        ),
      ),
    );
  }
}

class AllApplicationsHeader extends StatelessWidget {
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
      child: DataTable(
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
              DataCell(Text(job['salary'] ?? 'N/A')),
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
    );
  }
}