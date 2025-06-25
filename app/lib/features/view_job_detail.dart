import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:app/models/models.dart';
import 'package:flutter/material.dart';

class ViewJobDetail extends StatefulWidget {
  final Function(PageType) onNavigate;
  final int jobId;
  const ViewJobDetail({
    super.key,
    required this.jobId,
    required this.onNavigate
  });
  _ViewJobDetailState createState() => _ViewJobDetailState();
}

class _ViewJobDetailState extends State<ViewJobDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ViewJobDetailCard(jobId: widget.jobId)
          ],
        ),
      ),
    );
  }
}

class ViewJobDetailCard extends StatefulWidget {
  final int jobId;
  const ViewJobDetailCard({super.key, required this.jobId});
  @override
  _ViewJobDetailCardState createState() => _ViewJobDetailCardState();
}

class _ViewJobDetailCardState extends State<ViewJobDetailCard> {
  Job? job;
  bool isLoading = true;
  String? error;
  User? employer;

  @override
  void initState() {
    super.initState();
    _loadJobDetail();
  }

  Future<void> _loadJobDetail() async {
    try {
      final fetchedJob = await JobService.fetchJobById(widget.jobId);
      final fetchedEmployer = await UserService.fetchUserById(fetchedJob.employer_id);
      setState(() {
        job = fetchedJob;
        employer = fetchedEmployer;
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                const SizedBox(height: 10.0),
                Text(job?.title ?? '', style: AppText.textXl.merge(AppText.fontSemibold)),
                const SizedBox(height: 5.0),
                LinearProgressIndicator(
                  value: 1,
                  backgroundColor: Colors.grey[300],
                  color: AppColor.primary,
                  minHeight: 2,
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text('🏢 Company:', style: AppText.fontSemibold),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        job?.company ?? '',
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1,                     
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text('📍 Location:', style: AppText.fontSemibold),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        job?.location ?? '',
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1,                     
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text('💰 Salary:', style: AppText.fontSemibold),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        job?.salary ?? '',
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1,                     
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text('⏰ Type:', style: AppText.fontSemibold),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        job?.type ?? '',
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1,                     
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text('👤 Contact Person:', style: AppText.fontSemibold),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        employer?.fullName ?? '',
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1,                     
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Text('✉️ Contact Email:', style: AppText.fontSemibold),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        employer?.email ?? '',
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1,                     
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Text('Job Description', style: AppText.textLg.merge(AppText.fontSemibold)),
                const SizedBox(height: 5.0),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  clipBehavior: Clip.hardEdge, 
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Make children fill vertically
                      children: [
                        SizedBox(
                          width: 10.0,
                          child: Container(
                            color: AppColor.primary,
                            child: Text(
                              'l',
                              style: AppText.textPrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(job?.description ?? ''),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}