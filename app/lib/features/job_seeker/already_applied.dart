import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';

class AlreadyApplied extends StatefulWidget {
  final Function(PageType) onNavigate;
  final Job job;
  final int userId;
  const AlreadyApplied({
    super.key, 
    required this.onNavigate,
    required this.job,
    required this.userId,
  });

  @override
  _AlreadyAppliedState createState() => _AlreadyAppliedState();
}

class _AlreadyAppliedState extends State<AlreadyApplied> {
  Application? application;
  String? errorMessage;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadApplication();
  }

  void _loadApplication() async {
    try {
      application = await ApplicationService.getApplicationByJobAndUser(widget.job.id, widget.userId);
    } catch (e) {
      errorMessage = 'Failed to load application: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
        endDrawer: const OffcanvasNavigation(),
        body: const Center(child: CircularProgressIndicator(color: AppColor.info, strokeWidth: 6)),
      );
    }

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('Apply for ${widget.job.title} at ${widget.job.location}', style: AppText.textXl.merge(AppText.fontSemibold))),
              Card(
                color: const Color.fromARGB(255, 210, 245, 227),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Column(
                    children: [
                      Text('✅ You have already applied for this position!', style: AppText.textSuccess),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: Text('Your application status is ${application?.status}', style: AppText.fontSemibold.merge(AppText.textSuccess)),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          BackToJobListingButton(),
                          const SizedBox(width: 5),
                          AppliedAlreadyBackButton(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}