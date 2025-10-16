import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AlreadyApplied extends HookWidget {
  final Map<String, dynamic> job; 
  final int userId;

  const AlreadyApplied({
    super.key, 
    required this.job,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final application = useState<Map<String, dynamic>>({});

    useEffect(() {
      void fetchData() async {
        try {
          final res = await ApplicationService.getApplicationByJobAndUser(job['id'], userId);
          application.value = res;
          loading.value = false;
        } catch (e) {
          debugPrint('$e');
        }
      }
      fetchData();
      return null;
    }, []);
    if (loading.value) {
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
              Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('Apply for ${job['title']} at ${job['location']}', style: AppText.textXl.merge(AppText.fontSemibold))),
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
                        child: Text('Your application status is ${application.value['status']}', style: AppText.fontSemibold.merge(AppText.textSuccess)),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          AppButton(
                            label: 'Back to Job Listing',
                            textSize: 12, 
                            onPressed: () => navigateTo(context, const JobSeekerDashboard()),
                            visualDensityY: -2,
                          ),
                          const SizedBox(width: 5),
                          AppButton(
                            label: 'Back',
                            textSize: 12, 
                            onPressed: () => Navigator.of(context).pop(),
                            visualDensityY: -2,
                            backgroundColor: AppColor.secondary,
                          ),
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