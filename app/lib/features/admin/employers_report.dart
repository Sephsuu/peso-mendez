import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/services/verification_service.dart';
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
    final reload = useState(false);
    final find = useState('');
    final activeTab = useState('All Employers');
    final initialEmployers = useState<List<Map<String, dynamic>>>([]);
    final employers = useState<List<Map<String, dynamic>>>([]); 
    final filteredEmployers = useState<List<Map<String, dynamic>>>([]); 
    final verifiedIds = useState<List<dynamic>>([]);

    void setFind(String newVal) {
      find.value = newVal;
    }    

    void setActiveTab(String tab) {
      activeTab.value = tab;
    }

    useEffect(() {
      void fetchData() async {
        try {
          final res = await UserService.getUserByRole("employer");
          final verificationRes = await VerificationService.getVerificationsByRole('employer');
          initialEmployers.value = res;
          verifiedIds.value = verificationRes
          .map((v) => v['employer_id'])
          .toList();
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
      if (activeTab.value == 'All Employers') { 
        employers.value = initialEmployers.value.where((user) => !verifiedIds.value.contains(user['id'])).toList(); 
      } else { 
        employers.value = initialEmployers.value.where((user) => verifiedIds.value.contains(user['id'])).toList(); 
      }
      return;
    }, [activeTab.value, initialEmployers.value]);

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
            Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  label: 'All Employers', 
                  onPressed: () => setActiveTab('All Employers'),
                  visualDensityY: -3,
                  backgroundColor: activeTab.value == 'All Employers' ? AppColor.primary : Colors.grey,
                  foregroundColor: AppColor.light,
                  borderRadius: 0,
                ),
                AppButton(
                  label: 'Pending Employers', 
                  onPressed: () => setActiveTab('Pending Employers'),
                  visualDensityY: -3,
                  backgroundColor: activeTab.value == 'Pending Employers' ? AppColor.primary : Colors.grey,
                  foregroundColor: AppColor.light,
                  borderRadius: 0,
                )
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
      )
    );
  }
}