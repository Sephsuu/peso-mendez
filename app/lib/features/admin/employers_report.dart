import 'package:app/core/components/alert.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmployersReport extends HookWidget {
  
  const EmployersReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final loading = useState(true);
    final find = useState('');
    final employers = useState<List<Map<String, dynamic>>>([]); 
    final filteredEmployers = useState<List<Map<String, dynamic>>>([]); 

    void setFind(String newVal) {
      find.value = newVal;
    }    

    useEffect(() {
      void fetchData() async {
        try {
          final res = await UserService.getUserByRole("employer");
          employers.value = res;
          loading.value = false;
        } catch (e) { 
          if (!context.mounted) return;
          showAlertError(context, "Error: $e"); 
        }
      }
      fetchData();
      return null;
    }, []);

    useEffect(() {
      if (find.value.isEmpty) {
        filteredEmployers.value = employers.value;
      } else {
        filteredEmployers.value = employers.value.where((item) {
          final fullName = item["full_name"]?.toLowerCase() ?? '';
          final email = item["email"]?.toLowerCase() ?? '';
          return fullName.contains(find.value.toLowerCase()) || email.contains(find.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [find.value, employers.value]);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("📄 Employers Report", style: AppText.textXl.merge(AppText.fontSemibold)),
                GestureDetector(
                  child: Text('⬅️ Back', style: AppText.textPrimary,),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(
              width: screenWidth * 0.9,
              child: TextField(
                style: AppText.textXs,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.light,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  labelText: 'Job title, keywords, or company',
                  labelStyle: AppText.textSm,
                  border: const OutlineInputBorder()
                ),
                onChanged: (value) => setFind(value),
              ),
            ),
            EmployersTable(
              loading: loading.value,
              employers: filteredEmployers.value
            ),
          ],
        ),
      ),
    );
  }
}

class EmployersTable extends StatelessWidget {
  final List<Map<String, dynamic>> employers;
  final bool loading;
  const EmployersTable({
    super.key,
    required this.employers,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {

    if (loading) {
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
        rows: employers.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return DataRow(
            cells: [
              DataCell(Text((index + 1).toString())),
              DataCell(Text(item["full_name"] ?? 'N/A')),
              DataCell(Text(item["email"] ?? 'N/A')),
              DataCell(Text(item["username"] ?? 'N/A')),
              DataCell(Text(item["contact"] ?? 'N/A')),
              DataCell(Text(item["created_at"] ?? 'N/A')),
            ]
          );
        }).toList()
      ),
    );
  }
}