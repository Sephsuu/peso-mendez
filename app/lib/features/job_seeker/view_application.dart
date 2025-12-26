import 'package:app/core/components/alert.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/components/text.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/shared/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:app/core/hooks/utils.dart';

class ViewApplication extends HookWidget {
  final Map<String, dynamic> application;

  const ViewApplication({
    super.key,
    required this.application
  });

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final loading = useState(true);
    final isSaved = useState(false);
    final isApplied = useState(false);

    useEffect(() {
      void fetchData() async {
        if (claims.isNotEmpty) {
          final saved = await JobService.getSavedJobByUserJob(claims['id'], application['job_id']);
          final applied = await ApplicationService.getApplicationByJobAndUser(application['job_id'], claims['id']);
          isSaved.value = saved.isNotEmpty;
          isApplied.value = applied.isNotEmpty;
          loading.value = false;
        }
      }
      fetchData();
      return null;
    }, [claims, isSaved.value]);

    void applyJob() async {
      try {
        final existingApp = await ApplicationService.getApplicationByJobAndUser(application["job_id"], claims['id']);
        if (existingApp.isEmpty) {
          final applySuccess = await ApplicationService.createApplication(application["job_id"], claims['id']);
          if (applySuccess.isNotEmpty) {
            if (!context.mounted) return;
            AppSnackbar.show(
              context, 
              message: 'Successfully applied for job ${application["title"]}',
              backgroundColor: AppColor.success
            );
            isApplied.value = !isApplied.value;
          }
        } 
      } catch (e) { 
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: '$e',
          backgroundColor: AppColor.danger
        );
      }
    }

    void unapplyJob() async {
      final applySuccess = await ApplicationService.deleteApplicationByJobUser(application["job_id"], claims['id']);
      if (applySuccess.isNotEmpty) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: 'Successfully unapplied for job ${application["title"]}',
          backgroundColor: AppColor.success
        );
        isApplied.value = !isApplied.value;
      }
    }

    void saveJob() async {
      try {
        final res = await JobService.saveJob(claims['id'], application['job_id']);
        if (res.isNotEmpty) {
          Fluttertoast.showToast(
            msg: 'Announcement created sucesssfully',
            toastLength: Toast.LENGTH_LONG, 
            gravity: ToastGravity.TOP,
            backgroundColor: AppColor.light,
            textColor: AppColor.dark
          );
        }
        isSaved.value = !isSaved.value;
      } catch (e) { 
        if (!context.mounted) return;
        showAlertError(context, 'Error $e'); 
      }
    }

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: !loading.value ? SingleChildScrollView(
        child: Column(
          children: [
            ViewApplicationCover(
              application: application,
              isApplied: isApplied.value,
              isSaved: isSaved.value,
              saveJob: saveJob,
              applyJob: applyJob, unapplyJob: unapplyJob,
            ),
            JobDescriptionCard(description: application["description"]),
            JobDetailsCard(application: application),
            AboutCompanyCard(
              claims: claims,
              application: application
            ),
            const Footer()
          ],
        ),
      ) : const Loader(),
    );
  }
}

class ViewApplicationCover extends StatelessWidget {
  final Map<String, dynamic> application;
  final bool isApplied;
  final bool isSaved;
  final void Function() saveJob;
  final void Function() applyJob;
  final void Function() unapplyJob;
  
  const ViewApplicationCover({
    super.key,
    required this.application,
    required this.isApplied,
    required this.isSaved,
    required this.saveJob,
    required this.applyJob, required this.unapplyJob,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      width: double.infinity,  // full width
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,   
          end: Alignment.bottomRight, 
          colors: [
            Color.fromARGB(255, 32, 64, 192),           
            Color.fromARGB(255, 104, 129, 255),             
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            text: application["title"], 
            style: AppText.textLight.merge(AppText.fontExtraBold).merge(AppText.textTxl),
          ),
          const SizedBox(height: 5),
          Text(
            application["company"], 
            style: AppText.textLight.merge(AppText.fontSemibold).merge(AppText.textXl),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 5),
          Wrap(
            spacing: 20,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _iconText(Icons.location_on, application["location"]),
              _iconText(Icons.monetization_on, formatToPeso(application["salary"])),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _iconText(Icons.work, application["type"]),
              _iconText(
                Icons.calendar_month,
                DateFormat("MMM d, y")
                    .format(DateTime.parse(application["posted_on"])),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              isSaved ? AppButton(
                label: 'Saved', 
                onPressed: () {},
                backgroundColor: AppColor.warning,
                foregroundColor: AppColor.dark,
                visualDensityY: -2,
              ) : AppButton(
                label: 'Save Job', 
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AppModal(
                        title: 'Save job ${application["title"]} at ${application["location"]}?',
                        titleStyle: AppText.fontSemibold.merge(AppText.textLg),
                        confirmLabel: "Save Job",
                        confirmBackground: AppColor.primary,
                        confirmForeground: AppColor.light,
                        onConfirm: saveJob,
                      );
                    }
                  );
                },
                foregroundColor: AppColor.dark,
                backgroundColor: AppColor.light,
                visualDensityY: -2,
              ),
              
              const SizedBox(width: 10),
              isApplied ? AppButton(
                label: 'Applied', 
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AppModal(
                        title: 'Are you sure to unapply for job ${application["title"]} at ${application["location"]}',
                        titleStyle: AppText.fontSemibold.merge(AppText.textLg),
                        confirmLabel: "Unapply",
                        confirmBackground: AppColor.primary,
                        confirmForeground: AppColor.light,
                        onConfirm: unapplyJob,
                      );
                    }
                  );
                },
                backgroundColor: AppColor.success,
                foregroundColor: AppColor.light,
                visualDensityY: -2,
              ) : AppButton(
                label: 'Apply Job', 
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (context) {
                      return AppModal(
                        title: 'Apply for ${application["title"]} at ${application["location"]}',
                        titleStyle: AppText.fontSemibold.merge(AppText.textLg),
                        message: 'You\'re about to apply for: ${application["title"]} at ${application["location"]}. Your information will be shared with the employer.',
                        confirmLabel: "Apply",
                        confirmBackground: AppColor.primary,
                        confirmForeground: AppColor.light,
                        onConfirm: applyJob,
                      );
                    }
                  );
                },
                foregroundColor: AppColor.dark,
                backgroundColor: AppColor.light,
                visualDensityY: -2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20.0, color: Colors.white),
        const SizedBox(width: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200), // control wrap width
          child: Text(
            text,
            style: AppText.textLight.merge(AppText.textMd),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class JobDescriptionCard extends StatelessWidget {
  final String description;

  const JobDescriptionCard({
    super.key,
    required this.description
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: AppColor.light,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( 
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.file_copy, size: 20),
                  const SizedBox(width: 10),
                  Text("Job Description", style: AppText.textLg.merge(AppText.fontSemibold))
                ]
              ),
              const SizedBox(height: 5),
              Text(description)
            ],
          ),
        ),
      ),
    );
  }
}

class JobDetailsCard extends StatelessWidget {
  final Map<String, dynamic> application;

  const JobDetailsCard({
    super.key,
    required this.application
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: AppColor.light,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( 
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.info, size: 20),
                  const SizedBox(width: 10),
                  Text("Job Details", style: AppText.textLg.merge(AppText.fontSemibold))
                ]
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Job Title:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(application["type"]),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Salary:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(formatToPeso(application["salary"])),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Location:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(application["location"]),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Date Posted:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(DateFormat("MMM d, y").format(DateTime.parse(application["posted_on"])).toString()),
                  )
                ],
              ),
              const SizedBox(height: 8),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Text("Visibility:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Text(application["visibility"]),
              //     )
              //   ],
              // ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Job Status:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(application["status"]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutCompanyCard extends StatelessWidget {
  final Map<String, dynamic> claims;
  final Map<String, dynamic> application;

  const AboutCompanyCard({
    super.key,
    required this.application,
    required this.claims
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: AppColor.light,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row( 
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.business, size: 20),
                  const SizedBox(width: 10),
                  Text("About the Company", style: AppText.textLg.merge(AppText.fontSemibold))
                ]
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.primary,  
                      width: 2.0,        
                    ),
                    color: AppColor.light,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Icon(Icons.business, size: 50)),
                ),
              ),
              const SizedBox(height: 15),
              Center(child: Text(application["full_name"], style: AppText.textMd.merge(AppText.fontSemibold))),
              Center(child: Text("Employer", style: AppText.textSm.merge(AppText.fontSemibold).merge(AppText.textSecondary))),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail, size: 20, color: AppColor.primary),
                  const SizedBox(width: 5),
                  Text(application["email"], style: AppText.textSm)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 20, color: AppColor.primary),
                  const SizedBox(width: 5),
                  Text(application["contact"], style: AppText.textSm)
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.light,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    )
                  ),
                  onPressed: () => navigateTo(context, Messages(user: claims, otherUserId: application['employer_id'])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.mail, size: 20, color: AppColor.light),
                      const SizedBox(width: 5),
                      Text("Send Message", style: AppText.textSm)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}