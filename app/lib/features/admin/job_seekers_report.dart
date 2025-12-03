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
      body: SingleChildScrollView(
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
                  onPressed: () {
                    print(jobSeekers.value);
                    final rows = PdfExporter.mapToRowList(
                      data: jobSeekers.value.map((e) => Map<String, dynamic>.from(e)).toList(),
                      keys: ["full_name", "email", "username", "contact", "sex", "clientele", "highest_education", "citmun"],
                    );


                    PdfExporter.exportTable(
                      title: "Active Job Seekers Report",
                      headers: ["Full Name", "Email Address", "Username", "Contact Number", "Sex", "Clientele", "Highest Education", "City/Municipality"],
                      rows: rows,
                    );
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
              DataCell(Text(user["created_at"] ?? 'N/A')),
            ],
          );
        }).toList(),
        ),
      ),
    );
  }
}