import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ViewJobDetail extends StatelessWidget {
  final Function(PageType) onNavigate;
  final int jobId;

  const ViewJobDetail({
    super.key,
    required this.jobId,
    required this.onNavigate
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ViewJobDetailCard(jobId: jobId),
            const SizedBox(height: 200),
            const Footer(),
          ],
        ),
      ),
    );
  }
}


class ViewJobDetailCard extends HookWidget {
  final int jobId;
  const ViewJobDetailCard({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context) {
    final job = useState<Map<String, dynamic>>({});
    final employer = useState<Map<String, dynamic>>({});
    final loading = useState(true);
    final userId = useState(0);

    useEffect(() {
      void fetchData() async {
        try {
          final fetchedJob = await JobService.getJobById(jobId);
          final fetchedEmployer = await UserService.getUserById(fetchedJob['employer_id']);
          final fetchedUser = await AuthService.getClaims();
          job.value = fetchedJob;
          employer.value = fetchedEmployer;
          userId.value = fetchedUser['id'];
          loading.value = false;
        } catch (e) {
          print('ERROR 1');
          throw Exception(e);
        }
      }
      fetchData();
      return null;
    }, []);

    if (loading.value || job.value.isEmpty || employer.value.isEmpty || userId.value == 0) {
      return const Loader();
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                const SizedBox(height: 10.0),
                Text(job.value['title'], style: AppText.textXl.merge(AppText.fontSemibold)),
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
                        job.value['company'],
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
                        job.value['location'],
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
                        job.value['salary'],
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
                        job.value['type'],
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
                        employer.value['full_name'],
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
                        employer.value['email'],
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              job.value['description'],
                              softWrap: true, // optional, true by default
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                ViewJobDetailButtons(job: job.value, userId: userId.value),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ViewJobDetailButtons extends StatelessWidget {
  final Map<String, dynamic> job;
  final int userId;

  const ViewJobDetailButtons({
    super.key,
    required this.job,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ViewJobApplyJobButton(job: job, userId: userId),
        const SizedBox(width: 10),
        ViewJobSendMessageButton(),
        const SizedBox(width: 10),
        ViewJobBackButton(),
      ],
    );
  }
}
