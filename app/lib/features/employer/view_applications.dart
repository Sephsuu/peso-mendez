import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
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

  String? _appliedJob;
  String? _appliedLocation;
  String? _appliedStatus;

  Key _tableKey = UniqueKey();

  bool isLoading = true;

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
      isLoading = false;
    } catch (e) {
      const Scaffold(body: CircularProgressIndicator());
    } 
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(padding: EdgeInsets.only(top: 50),child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6));
    }

    return Column(
      children: [
        ViewApplicationDropdownSelect(items: jobs, initialValue: _selectedJob, placeholder: 'All Jobs', onChanged: (value) { setState(() { _selectedJob = value; }); }),
        const SizedBox(height: 7),
        ViewApplicationDropdownSelect(items: locations, initialValue: _selectedLocation, placeholder: 'All Locations', onChanged: (value) { setState(() { _selectedLocation = value; }); }),
        const SizedBox(height: 7),
        ViewApplicationDropdownSelect(items: statuses, initialValue: _selectedStatus, placeholder: 'All Statuses', onChanged: (value) { setState(() { _selectedStatus = value; }); }),
        const SizedBox(height: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () {
            setState(() {
              _appliedJob = _selectedJob;
              _appliedLocation = _selectedLocation;
              _appliedStatus = _selectedStatus;

              _tableKey = UniqueKey(); 
            });
          }, 
          child: const Text('Filter')
        ),

        ViewApplicationTable(
          key: _tableKey,
          job: _appliedJob ?? 'A',
          location: _appliedLocation ?? 'A',
          status: _appliedStatus ?? 'A',
          userId: widget.userId,
        ),

      ],
    );
  }
}

class ViewApplicationTable extends StatefulWidget {
  final int userId;
  final String job;
  final String location;
  final String status;

  const ViewApplicationTable({
    super.key,
    required this.job,
    required this.location,
    required this.status,
    required this.userId,
  });

  @override
  _ViewApplicationTableState createState() => _ViewApplicationTableState();
}
class _ViewApplicationTableState extends State<ViewApplicationTable> {
  List<Map<String, dynamic>> applications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppropriateData();
  }

  // This method decides which fetch to use
  void _fetchAppropriateData() {
    if (widget.job != "A" || widget.location != "A" || widget.status != "A") {
      debugPrint('Fetching filtered data');  
      _fetchDataFilter();
    } else {
      debugPrint('Fetching all data');
      _fetchData();
    }
  }

  @override
  void didUpdateWidget(covariant ViewApplicationTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.job != oldWidget.job ||
        widget.location != oldWidget.location ||
        widget.status != oldWidget.status) {
      _fetchAppropriateData();
    }
  }

  void _fetchData() async {
    try {
      final List<Map<String, dynamic>> applicationsRes = await ApplicationService.getApplicationsByEmployer(widget.userId);
      setState(() {
        applications = applicationsRes;
      });
      isLoading = false;
    } catch (e) {
      return;
    }
  }

  void _fetchDataFilter() async {
    try {
      final List<Map<String, dynamic>> applicationsRes = await ApplicationService.getApplicationsByEmployerFilter(
        widget.userId, widget.job, widget.location, widget.status
      );
      setState(() {
        applications = applicationsRes;
      });
      isLoading = false;
    } catch (e) {
      // Use ScaffoldMessenger for errors, not Scaffold
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading data')));
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
          DataColumn(label: Text('Applicant')),
          DataColumn(label: Text('Job Title')),
          DataColumn(label: Text('Job Location')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Applied On')),
          DataColumn(label: Text('Resume')),
          DataColumn(label: Text('Action')),
        ],
        rows: applications.map((application) {
          return DataRow(
            cells: [
              DataCell(Text(application['full_name'] ?? 'N/A')),
              DataCell(Text(application['title']?.toString() ?? 'N/A')),
              DataCell(Text(application['location'] ?? 'N/A')),
              DataCell(ViewApplicationUpdateStatus(initialValue: application["status"], applicationId: application["id"],)),
              DataCell(Text(application['applied_on'] ?? 'N/A')),
              DataCell(Text(application['resume'] ?? 'No Resume')),
              DataCell(Text(application['action'] ?? 'N/A')),
            ],
          );
        }).toList()
      ),
    );
  }
}