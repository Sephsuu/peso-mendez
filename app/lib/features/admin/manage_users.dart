import 'package:app/core/components/alert.dart';
import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ManageUsers extends HookWidget {
  
  const ManageUsers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final loading = useState(true);
    final reload = useState(false);
    final find = useState("");
    final users = useState<List<Map<String, dynamic>>>([]);
    final filteredUsers = useState<List<Map<String, dynamic>>>([]);

    void setFind(String newVal) {
      find.value = newVal;
    }    


    void setReload() {
      reload.value = !reload.value;
    }

    useEffect(() {
      void fetchData () async {
        try {
          final res = await UserService.getAllUsers();
          users.value = res;
        } catch (e) { throw Exception(e); }
        finally { loading.value = false; }
      }
      fetchData();
      return null;
    }, [reload.value]);

    useEffect(() {
      if (find.value.isEmpty) {
        filteredUsers.value = users.value;
      } else {
        filteredUsers.value = users.value.where((item) {
          final fullName = item["full_name"]?.toLowerCase() ?? '';
          final email = item["email"]?.toLowerCase() ?? '';
          return fullName.contains(find.value.toLowerCase()) || email.contains(find.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [find.value, users.value]);

    final activeUsers = filteredUsers.value
    .where((user) => user['status'] == 'active')
    .toList();

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
                  Text("Manage Users", style: AppText.textXl.merge(AppText.fontSemibold)),
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
            SizedBox(
              width: screenWidth * 0.9,
              child: TextField(
                style: AppText.textXs,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.light,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                  labelText: 'Search for a user',
                  labelStyle: AppText.textSm,
                  border: const OutlineInputBorder()
                ),
                onChanged: (value) => setFind(value),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: UsersTable(
                users: activeUsers, 
                loading: loading.value,
                setReload: setReload,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class UsersTable extends StatefulWidget {
  final List<Map<String, dynamic>> users;
  final bool loading;
  final VoidCallback setReload;

  const UsersTable({
    super.key,
    required this.users,
    required this.loading,
    required this.setReload,
  });

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  final TextEditingController _reason = TextEditingController();
  
  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (widget.loading) {
      return const Padding(padding: EdgeInsets.only(top: 50),child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6));
    }

    void deactivateUser(Map<String, dynamic> user) async {
      try {
        final res = await UserService.deactivateUser(user["id"], _reason.text);
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User successfully deactivated.'),
              duration: Duration(seconds: 2),
            ),
          );
          widget.setReload();
        }
        if (!context.mounted) return;
      } catch (e) { showAlertError(context, "Error $e"); }
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
              DataColumn(label: Text('Contact Number')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Role')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Registered At')),
              DataColumn(label: Text('Actions')),
            ], 
            rows: widget.users.asMap().entries.map((entry) {
              int index = entry.key;     
              var user = entry.value;

              return DataRow(
                cells: [
                  DataCell(Text((index + 1).toString())),        
                  DataCell(Text(user["full_name"] ?? 'N/A')),
                  DataCell(Text(user["email"] ?? 'N/A')),
                  DataCell(Text(user["contact"] ?? 'N/A')),
                  DataCell(Text(user["username"] ?? 'N/A')),
                  DataCell(
                    user["role"] == 'job_seeker' ? (
                      const AppBadge(
                        text: 'Job Seeker', 
                        backgroundColor: Color.fromARGB(255, 205, 238, 250),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        foregroundColor: AppColor.dark,
                      )
                    ) : (
                      const AppBadge(
                        text: 'Employer', 
                        backgroundColor: Color.fromARGB(255, 215, 215, 215),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        foregroundColor: AppColor.dark,
                      )
                    )
                  ),
                  DataCell(
                    user["status"] == 'active' ? (
                      const AppBadge(
                        text: 'Active', 
                        backgroundColor: AppColor.success,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                      )
                    ) : (
                      const AppBadge(
                        text: 'Inactive', 
                        backgroundColor: AppColor.danger,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                      )
                    )
                  ),
                  DataCell(Text(formatDateOnly(user["created_at"]))),
                  DataCell(
                    AppButton(
                      label: 'Deactivate', 
                      onPressed: () {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AppModal(
                              title: 'Are you sure to deactivate user: ${user["full_name"]}',
                              onConfirm: () => deactivateUser(user),
                              confirmForeground: AppColor.light,
                              confirmBackground: AppColor.danger,
                              message: SizedBox(
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Please state the reason why user was deactivated.',
                                    ),
                                    const SizedBox(height: 12),
                                    AppInputField(
                                      label: 'Reason',
                                      initialValue: user['note'] ?? '',
                                      visualDensityY: 0,
                                      textSize: 16,
                                      controller: _reason,
                                    ),

                                  ],
                                ),
                              ),
                            );
                          }
                        );
                      },
                      visualDensityY: -4,
                      foregroundColor: AppColor.light,
                      backgroundColor: AppColor.danger,
                      textSize: 12,
                      isDisabled: user['status'] == 'inactive',
                    )
                  ),
                ]
              );
            }).toList(),
          ),
        )
      )
    );
  }
}
