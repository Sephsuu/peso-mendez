import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class JobSeekersReport extends StatelessWidget {
  final Function(PageType) onNavigate;
  
  const JobSeekersReport({
    super.key,
    required this.onNavigate
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("👥 Manage Users", style: AppText.textXl.merge(AppText.fontSemibold)),
                GestureDetector(
                  child: Text('⬅️ Back', style: AppText.textPrimary,),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            JobSeekersTable(),
          ],
        ),
      ),
    );
  }
}

class JobSeekersTable extends StatefulWidget {
  const JobSeekersTable({Key? key}) : super(key: key);

  @override
  _JobSeekersTableState createState() => _JobSeekersTableState();
}

class _JobSeekersTableState extends State<JobSeekersTable> {
  List<Map<String, dynamic>> jobSeekers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final List<Map<String, dynamic>> jobSeekersRes = await UserService.fetchUserByRole("job_seeker");
      setState(() {
        jobSeekers = jobSeekersRes;
      });
      isLoading = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(padding: EdgeInsets.only(top: 50),child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Full Name')),
          DataColumn(label: Text('E-mail Address')),
          DataColumn(label: Text('Username')),
          DataColumn(label: Text('Contact')),
          DataColumn(label: Text('Registered At')),
        ], 
        rows: jobSeekers.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user["id"].toString())),
              DataCell(Text(user["full_name"] ?? 'N/A')),
              DataCell(Text(user["email"] ?? 'N/A')),
              DataCell(Text(user["username"] ?? 'N/A')),
              DataCell(Text(user["contact"] ?? 'N/A')),
              DataCell(Text(user["created_at"] ?? 'N/A')),
            ]
          );
        }).toList()
      ),
    );
  }
}