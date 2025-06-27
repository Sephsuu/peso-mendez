import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/main.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';

class AlreadyApplied extends StatefulWidget {
  final Function(PageType) onNavigate;
  final int jobId;
  final int userId;
  const AlreadyApplied({
    super.key, 
    required this.onNavigate,
    required this.jobId,
    required this.userId,
  });

  @override
  _AlreadyAppliedState createState() => _AlreadyAppliedState();
}

class _AlreadyAppliedState extends State<AlreadyApplied> {
  Map<String, dynamic>? application;
  String? errorMessage;
  Job? job;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    // _loadApplication();
    _loadJobDetail();
  }

  // Future<void> _loadApplication() async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = null;
  //   });

  //   try {
  //     final appData = await ApplicationService.getApplicationByJobAndUser(widget.jobId, widget.userId);
  //     setState(() {
  //       application = appData;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = e.toString();
  //     });
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> _loadJobDetail() async {
    try {
      final fetchedJob = await JobService.fetchJobById(widget.jobId);
      setState(() {
        job = fetchedJob;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          child: Column(
            children: [
              Text('Apply for ${job?.title} at ${job?.location}')
            ],
          ),
        ),
      ),
    );
  }
}