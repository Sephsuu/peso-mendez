import 'dart:convert';

import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostNewJob extends StatelessWidget {
  final Function(PageType) onNavigate;

  PostNewJob({
    super.key,
    required this.onNavigate
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: PostNewJobForm(),
            ),
            Footer()
          ],
        ),
      ),
    );
  }
}

class PostNewJobForm extends StatefulWidget {
  const PostNewJobForm({super.key});

  _PostNewJobFormState createState() => _PostNewJobFormState();
}

class _PostNewJobFormState extends State<PostNewJobForm>  {
  final _formKey = GlobalKey<FormState>();
  int? employerId;

  final TextEditingController _jobTitle = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  String? _jobType;
  String? _visibility;

  List<String> types = ['Full-time', 'Part-time'];
  List<String> visibilities = ['Lite', 'Branded', 'Premium'];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    final data = await UserService.fetchLoggedUserData();
    setState(() {
      employerId = data?['id'] ?? 0;
    });
  }

  @override
  void dispose() {
    _jobTitle.dispose();
    _company.dispose();
    _location.dispose();
    _salary.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final jobTitleValue = _jobTitle.text.trim();
      final companyValue = _company.text.trim();
      final locationValue = _location.text.trim();
      final descriptionValue = _description.text.trim();
      final salaryValue = _salary.text.trim();
      final jobTypeValue = _jobType;
      final visibilityValue = _visibility;

      try {
        final url = Uri.parse('https://x848qg05-3005.asse.devtunnels.ms/jobs');

        final response = await http.post(
          url,
          headers: { 'Content-Type': 'application/json' },
          body: jsonEncode({
            "title": jobTitleValue,
            "company": companyValue,
            "location": locationValue,
            "salary": salaryValue,
            "type": jobTypeValue,
            "description": descriptionValue,
            "employerId": employerId,
            "visibility": visibilityValue
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Job successfully added.')),
          );

          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployerDashboard(onNavigate: (page) => globalNavigateTo?.call(page))));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('📝 Post a New Job', style: AppText.textXl.merge(AppText.fontSemibold)),
          ),
          PostNewJopTextField(controller: _jobTitle, label: 'Job Title'),
          const SizedBox(height: 10),
          PostNewJopTextField(controller: _company, label: 'Company'),
          const SizedBox(height: 10),
          PostNewJopTextField(controller: _location, label: 'Location'),
          const SizedBox(height: 10),
          PostNewJobDrowdownSelectRequired(items: types, label: 'Job Type', initialValue: _jobType, placeholder: 'Select Type', onChanged: (value) { setState(() { _jobType = value; });}),
          const SizedBox(height: 10),
          PostNewJobDrowdownSelectRequired(items: visibilities, label: 'Visibility', initialValue: _visibility, placeholder: 'Select Visibility', onChanged: (value) { setState(() { _visibility = value; });}),
          const SizedBox(height: 10),
          PostNewJopTextField(controller: _salary, label: 'Salary'),
          const SizedBox(height: 10),
          PostNewJopTextField(controller: _description, label: 'Job Description', maxLine: 4),
          const SizedBox(height: 20),
          Row(
            children: [
              PostJobButton(onPressed: _submitForm),
              const SizedBox(width: 15),
              PostJobBackButton(),
            ],
          )
          // RegisterDrowdownSelect(items: isOfw, initialValue: _isOfw, placeholder: 'Are you an OFW', onChanged: (value) { setState(() { _isOfw = value; }); }),
        ],
      ),
    );
  }
}

