import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class ManageUsers extends StatelessWidget {
  final Function(PageType) onNavigate;
  
  const ManageUsers({
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
            UsersTable(),
          ],
        ),
      ),
    );
  }
}

class UsersTable extends StatefulWidget {
  const UsersTable({Key? key}) : super(key: key);

  @override
  _UsersTableState createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      final List<Map<String, dynamic>> usersRes = await UserService.fetchUsers();
      setState(() {
        users = usersRes;
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