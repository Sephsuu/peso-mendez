import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/features/admin/view_employer_documents.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final tabs = ['Verified Employers', 'Pending Employers', 'Rejected Employers'];

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
          final verificationRes = await VerificationService.getVerificationsByRole('employer');
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
        employers.value = initialEmployers.value.where((user) => user['status'] == 'approved').toList(); 
      } else if (activeTab.value == 'Rejected Employers') { 
        employers.value = initialEmployers.value.where((user) => user['status'] == 'rejected').toList();
      } else {
        employers.value = initialEmployers.value.where((user) => user['status'] == 'pending').toList();
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
        final data = await VerificationService.updateVerificationStatus(id, status);
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
                    visualDensityY: -3,
                    backgroundColor: activeTab.value == tab 
                        ? AppColor.primary 
                        : Colors.grey,
                    foregroundColor: AppColor.light,
                    borderRadius: 0,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: screenWidth * 0.9,
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
            const SizedBox(height: 10),
            EmployersTable(
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
  final String activeTab;
  final List<Map<String, dynamic>> employers;
  final bool loading;
  final Function(int, String) updateVerificationStatus;

  const EmployersTable({
    super.key,
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
          columns:  [
            const DataColumn(label: Text('#')),
            const DataColumn(label: Text('Full Name')),
            const DataColumn(label: Text('E-mail Address')),
            const DataColumn(label: Text('Username')),
            const DataColumn(label: Text('Contact')),
            const DataColumn(label: Text('Registered At')),
            const DataColumn(label: Text('Documents')),
            const DataColumn(label: Text('Actions')),
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
                DataCell(
                  item["documents"] != null && item["documents"].toString().isNotEmpty
                      ? GestureDetector(
                          onTap: () async {
                            // Construct the full file URL
                            final String filePath = item["documents"];
                            final String fullUrl = filePath.startsWith("http")
                                ? filePath
                                : "$BASE_URL/$filePath";

                            final Uri uri = Uri.parse(fullUrl);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication, // opens in browser or PDF viewer
                              );
                            } else {
                              if (context.mounted) {
                                showAlertError(context, "Unable to open document.");
                              }
                            }
                          },
                          child: const Text(
                            'View Document',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : const Row(
                          children: [
                            Icon(Icons.folder_off, color: Colors.grey, size: 20),
                            SizedBox(width: 5),
                            Text('No Document', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                ),
                DataCell(
                  AppButton(
                    label: 'View Documents',
                    backgroundColor: AppColor.primary,
                    onPressed: () => navigateTo(context, ViewEmployerDocuments(employerId: item["employer_id"])),
                    visualDensityY: -3,
                  ),
                ),
              ]
            );
          }).toList()
        ),
      )
    );
  }
}