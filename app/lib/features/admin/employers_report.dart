import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/features/admin/view_employer_documents.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final tabs = ['Verified Employers', 'Pending Employers', 'Rejected Employers', 'Idle Employers'];

class EmployersReport extends HookWidget {
  const EmployersReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final loading = useState(true);
    final reload = useState(false);
    final find = useState('');
    final activeTab = useState('Verified Employers');
    final initialEmployers = useState<List<Map<String, dynamic>>>([]);
    final employers = useState<List<Map<String, dynamic>>>([]); 
    final filteredEmployers = useState<List<Map<String, dynamic>>>([]); 

    void setFind(String newVal) {
      find.value = newVal;
    }    

    void setActiveTab(String tab) {
      activeTab.value = tab;
    }

    useEffect(() {
      void fetchData() async {
        try {
          final verificationRes = await VerificationService.getAllEmployers();
          initialEmployers.value = verificationRes;
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
      if (activeTab.value == 'Verified Employers') { 
        employers.value = initialEmployers.value.where((user) => user['verification_status'] == 'approved').toList(); 
      } else if (activeTab.value == 'Rejected Employers') { 
        employers.value = initialEmployers.value.where((user) => user['verification_status'] == 'rejected').toList();
      } else if (activeTab.value == 'Idle Employers') { 
        employers.value = initialEmployers.value.where((user) => user['verification_status'] == null).toList();
      } else {
        employers.value = initialEmployers.value.where((user) => user['verification_status'] == 'pending').toList();
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

    void updateVerificationStatus(int id, String status) async {
      try {
        final data = await VerificationService.updateVerificationStatus(id, status, '');
        if (data.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Status updated to $status',
            backgroundColor: AppColor.success,
          );
          reload.value = !reload.value;
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: '$e',
          backgroundColor: AppColor.danger,
        );
      }
    }

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
                  Text("Employers Report", style: AppText.textXl.merge(AppText.fontSemibold)),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: tabs.map((tab) {
                  return AppButton(
                    label: tab,
                    onPressed: () => setActiveTab(tab),
                    disableShadow: true,
                    backgroundColor: Colors.transparent,
                    foregroundColor: activeTab.value == tab 
                        ? AppColor.primary 
                        : AppColor.muted,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  );
                }).toList(),
              ),
            ),
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
                      labelText: 'Search for an employer',
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
                    final rows = PdfExporter.mapToRowList(
                      data: initialEmployers.value,
                      keys: ["full_name", "email", "username", "contact", "employer_type", "sex", "highest_education", "citmun"],
                    );

                    PdfExporter.exportTable(
                      title: "Active Employers Report",
                      headers: ["Full Name", "Email Address", "Username", "Contact Number", "Employer Type", "Gender", "Highest Education", "City/Municipality"],
                      rows: rows,
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 10),
            EmployersTable(
              claims: claims,
              activeTab: activeTab.value,
              loading: loading.value,
              employers: filteredEmployers.value,
              updateVerificationStatus: updateVerificationStatus,
            ),
          ],
        ),
      ),
    );
  }
}

class EmployersTable extends StatelessWidget {
  final Map<String, dynamic> claims;
  final String activeTab;
  final List<Map<String, dynamic>> employers;
  final bool loading;
  final Function(int, String) updateVerificationStatus;

  const EmployersTable({
    super.key,
    required this.claims,
    required this.activeTab,
    required this.employers,
    required this.loading,
    required this.updateVerificationStatus
  });

  @override
  Widget build(BuildContext context) {
    

    if (loading) {
      return const Loader();
    }

    if (employers.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.business_outlined,
                size: 48,
                color: AppColor.muted,
              ),
              SizedBox(height: 12),
              Text(
                "No employers found",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Try changing the filter or check again later.",
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.muted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
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
            columns:  const [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('E-mail Address')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Employer Type')),
              DataColumn(label: Text('Gender')),
              DataColumn(label: Text('Highest Education')),
              DataColumn(label: Text('City/Municipality')),
              DataColumn(label: Text('Registered At')),
              DataColumn(label: Text('Actions')),
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
                  DataCell(Text(item["employer_type"] ?? 'N/A')),
                  DataCell(Text(item["sex"] ?? 'N/A')),
                  DataCell(Text(item["highest_education"] ?? 'N/A')),
                  DataCell(Text(item["citmun"] ?? 'N/A')),
                  DataCell(Text(formatDateOnly(item["created_at"]))),
                  DataCell(
                    AppButton(
                      label: 'View Documents',
                      backgroundColor: AppColor.primary,
                      onPressed: () => navigateTo(context, ViewEmployerDocuments(claims: claims)),
                      visualDensityY: -3,
                    ),
                  ),
                ]
              );
            }).toList()
          ),
        )
      ),
    );
  }
}
