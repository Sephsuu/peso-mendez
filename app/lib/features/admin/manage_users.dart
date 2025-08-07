import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ManageUsers extends HookWidget {
  final Function(PageType) onNavigate;
  
  const ManageUsers({
    super.key,
    required this.onNavigate
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final loading = useState(true);
    final find = useState("");
    final users = useState<List<Map<String, dynamic>>>([]);
    final filteredUsers = useState<List<Map<String, dynamic>>>([]);

    void setFind(String newVal) {
      find.value = newVal;
    }    

    useEffect(() {
      void fetchData () async {
        try {
          final res = await UserService.fetchUsers();
          users.value = res;
        } catch (e) { throw Exception(e); }
        finally { loading.value = false; }
      }
      fetchData();
      return null;
    }, []);

    useEffect(() {
      if (find.value.isEmpty) {
        filteredUsers.value = users.value;
      } else {
        filteredUsers.value = users.value.where((item) {
          final fullName = item["full_name"]?.toLowerCase() ?? '';
          return fullName.contains(find.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [find.value, users.value]);


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
            UsersTable(users: filteredUsers.value, loading: loading.value),
          ],
        ),
      ),
    );
  }
}

class UsersTable extends HookWidget {
  final List<Map<String, dynamic>> users;
  final bool loading;
  const UsersTable({
    super.key,
    required this.users,
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
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Registered At')),
          DataColumn(label: Text('Actions')),
        ], 
        rows: users.map((user) {
          return DataRow(
            cells: [
              DataCell(Text(user["id"].toString())),
              DataCell(Text(user["full_name"] ?? 'N/A')),
              DataCell(Text(user["email"] ?? 'N/A')),
              DataCell(Text(user["username"] ?? 'N/A')),
              DataCell(Text(user["role"] ?? 'N/A')),
              DataCell(Text(user["status"] ?? 'N/A')),
              DataCell(Text(user["created_at"] ?? 'N/A')),
              DataCell(Text(user["id"].toString())),
            ]
          );
        }).toList()
      ),
    );
  }
}