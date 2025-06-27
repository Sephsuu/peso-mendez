import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class ViewApplications extends StatelessWidget {
  final Function(PageType) onNavigate;
  final int userId;

  const ViewApplications({super.key, 
    required this.onNavigate,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: Column(
                children: [
                  const ViewApplicationHeader(),
                  ViewApplicationFilter(userId: userId)
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class ViewApplicationHeader extends StatelessWidget {

  const ViewApplicationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('📄 View Applications', style: AppText.textXl.merge(AppText.fontSemibold)),
        GestureDetector(
          child: Text('⬅️ Back', style: AppText.textPrimary,),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ViewApplicationFilter extends StatefulWidget {
  final int userId;

  const ViewApplicationFilter({
    super.key,
    required this.userId,
  });

  @override
  _ViewApplicationFilterState createState() => _ViewApplicationFilterState();
}
class _ViewApplicationFilterState extends State<ViewApplicationFilter> {
  List<String> jobs = [];
  List<String> statuses = ['Sent', 'Reviewed', 'Interview', 'Hired', 'Rejected'];
  List<String> skills = [];
  List<String> locations = [];

  String? _selectedJob;
  String? _selectedLocation;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _fetchData(widget.userId);
  }

  void _fetchData(employerId) async {
    try {
      final List<String> jobsRes = await JobService.getJobTitlesByEmployer(widget.userId);
      final List<String> locationsRes = await JobService.getJobLocationsByEmployer(widget.userId);
      setState(() {
        jobs = jobsRes;
        locations = locationsRes;
      });
    } catch (e) {
      Scaffold(body: CircularProgressIndicator());
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ViewApplicationDropdownSelect(items: jobs, initialValue: _selectedJob, placeholder: 'All Jobs', onChanged: (value) { setState(() { _selectedJob = value; }); }),
        const SizedBox(height: 7),
        ViewApplicationDropdownSelect(items: locations, initialValue: _selectedLocation, placeholder: 'All Locations', onChanged: (value) { setState(() { _selectedLocation = value; }); }),
        const SizedBox(height: 7),
        ViewApplicationDropdownSelect(items: statuses, initialValue: _selectedStatus, placeholder: 'All Statuses', onChanged: (value) { setState(() { _selectedStatus = value; }); }),
      ],
    );
  }
}