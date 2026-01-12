import 'package:app/core/components/alert.dart';
import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/components/text.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/employer/edit_job.dart';
import 'package:app/features/shared/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

final List<String> educationLevels = [
  "No grade completed",
  "Elementary Level",
  "Elementary Graduate",
  "Junior High School Level",
  "Junior High School Graduate",
  "Senior High School Level",
  "Senior High School Graduate",
  "High School Level (Non K-12)",
  "High School Graduate (Non K-12)",
  "Alternative Learning System",
  "Vocational Level",
  "College Level",
  "College Graduate",
  "Some Masteral Units",
  "Master's Degree Holder",
  "Some Doctorate Units",
];

class ViewJob extends HookWidget {
  final int jobId;
  const ViewJob({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);

    final job = useState<Map<String, dynamic>>({});
    final jobSkills = useState<List<String>>([]);
    final profileStrength = useState<double>(0);
    final educBg = useState<Map<String, dynamic>>({});

    final loading = useState(true);
    final isSaved = useState(false);
    final isApplied = useState(false);
    final applying = useState(false);

    /// =========================
    /// FETCH JOB DATA (SAFE)
    /// =========================
    useEffect(() {
      bool cancelled = false;

      Future<void> fetchData() async {
        if (claims.isEmpty) return;

        loading.value = true;

        // ✅ RESET STATE FIRST (prevents stale UI)
        isSaved.value = false;
        isApplied.value = false;

        try {
          final data = await JobService.getJobById(jobId);
          final res =
              await UserService.getUserProfileStrength(claims['id']);
          final jobSkillsRes =
              await JobService.getJobSkills(jobId);

          if (cancelled) return;

          job.value = data;
          jobSkills.value =
              jobSkillsRes.map((e) => e['skill']).cast<String>().toList();
          profileStrength.value = res;

          final saved = await JobService.getSavedJobByUserJob(
              claims['id'], jobId);
          final applied =
              await ApplicationService.getApplicationByJobAndUser(
                  jobId, claims['id']);

          if (cancelled) return;

          isSaved.value = saved.isNotEmpty;
          isApplied.value = applied.isNotEmpty;
        } finally {
          if (!cancelled) loading.value = false;
        }
      }

      fetchData();

      return () {
        cancelled = true;
      };
    }, [jobId, claims['id']]);

    useEffect(() {
      if (claims['id'] == null) return null;
      void fetchData() async {
        try {
          loading.value =  true;
          final data = await UserService.getUserEducationalBackground(claims['id']);
          educBg.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
      return null;
    }, [claims['id']]);

    /// =========================
    /// SAVE / UNSAVE JOB
    /// =========================
    void toggleSaveJob() async {
      try {
        if (isSaved.value) {
          await JobService.unsaveJob(
              claims['id'], job.value['id']);
          isSaved.value = false;

          if (context.mounted) {
            AppSnackbar.show(
              context,
              message: 'Job removed from saved list',
              backgroundColor: AppColor.warning,
            );
          }
        } else {
          if (profileStrength.value < 0.55) {
            return showDialog(
              context: context, 
              builder: (context) {
                return AppModal(
                  title: 'Your profile strength must be atleast 60% in order to save jobs.',
                  titleStyle: AppText.fontSemibold.merge(AppText.textLg),
                  confirmLabel: "I understand.",
                  confirmBackground: AppColor.primary,
                  confirmForeground: AppColor.light,
                );
              }
            );
          }
          await JobService.saveJob(
          claims['id'], job.value['id']);
          isSaved.value = true;

          if (context.mounted) {
            AppSnackbar.show(
              context,
              message: 'Job successfully saved',
              backgroundColor: AppColor.success,
            );
          }
        }
      } catch (_) {
        if (context.mounted) {
          showAlertError(context, 'Failed to update saved jobs');
        }
      }
    }

    /// =========================
    /// APPLY JOB (SAFE)
    /// =========================
    void applyJob() async {
      if (applying.value) return;

      final seekerEdu = educBg.value["highest_education"];
      final requiredEdu = job.value["required_education"];

      final seekerIndex = educationLevels.indexOf(seekerEdu);
      final requiredIndex = educationLevels.indexOf(requiredEdu);

      // ❌ Invalid education values
      if (seekerIndex == -1 || requiredIndex == -1) {
        AppSnackbar.show(
          context,
          message: "Unable to verify educational background.",
          backgroundColor: AppColor.danger,
        );
        return;
      }

      // ❌ Education NOT met
      if (seekerIndex < requiredIndex) {
        showDialog(
          context: context,
          builder: (_) => const AppModal(
            title: 'Education requirement not met.',
            message:
                'Your highest educational attainment does not meet the minimum requirement for this job.',
            confirmLabel: "I understand",
            confirmBackground: AppColor.primary,
            confirmForeground: AppColor.light,
          ),
        );
        return;
      }

      // ✅ PASSED education check — now proceed
      applying.value = true;

      try {
        await ApplicationService.createApplication(
          job.value["id"],
          claims['id'],
        );

        isApplied.value = true;

        AppSnackbar.show(
          context,
          message: 'Successfully applied for ${job.value["title"]}',
          backgroundColor: AppColor.success,
        );
      } catch (_) {
        AppSnackbar.show(
          context,
          message: 'Failed to apply for job',
          backgroundColor: AppColor.danger,
        );
      } finally {
        applying.value = false;
      }
    }


    /// =========================
    /// UNAPPLY JOB (SAFE)
    /// =========================
    void unapplyJob() async {
      if (applying.value) return;
      applying.value = true;

      try {
        final result =
            await ApplicationService.deleteApplicationByJobUser(
          job.value["id"],
          claims['id'],
        );

        if (result.isNotEmpty && context.mounted) {
          isApplied.value = false;

          AppSnackbar.show(
            context,
            message:
                'Successfully unapplied from ${job.value["title"]}',
            backgroundColor: AppColor.success,
          );
        }
      } catch (_) {
        if (context.mounted) {
          AppSnackbar.show(
            context,
            message: 'Failed to unapply',
            backgroundColor: AppColor.danger,
          );
        }
      } finally {
        applying.value = false;
      }
    }

    /// =========================
    /// UI
    /// =========================
    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) {
          Scaffold.of(context).openDrawer();
        },
      ),
      endDrawer: const OffcanvasNavigation(),
      body: loading.value
          ? const Loader()
          : SingleChildScrollView(
              child: Column(
                children: [
                  ViewApplicationCover(
                    claims: claims,
                    job: job.value,
                    isApplied: isApplied.value,
                    isSaved: isSaved.value,
                    toggleSaveJob: toggleSaveJob,
                    applyJob: applyJob,
                    unapplyJob: unapplyJob,
                  ),
                  JobDescriptionCard(
                    description: job.value["description"],
                    jobSkills: jobSkills.value,
                  ),
                  JobDetailsCard(job: job.value),
                  if (claims['id'] != job.value['employer_id'])
                    AboutCompanyCard(
                        claims: claims, job: job.value),
                  const Footer(),
                ],
              ),
            ),
    );
  }
}

class ViewApplicationCover extends StatelessWidget {
  final Map<String, dynamic> claims;
  final Map<String, dynamic> job;
  final bool isApplied;
  final bool isSaved;
  final void Function() applyJob;
  final void Function() unapplyJob;
  final void Function() toggleSaveJob;
  
  const ViewApplicationCover({
    super.key,
    required this.claims,
    required this.job,
    required this.isApplied,
    required this.applyJob,
    required this.unapplyJob,
    required this.isSaved,
    required this.toggleSaveJob
  });

  @override
  Widget build(BuildContext context) {
    

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      width: double.infinity,  // full width
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,    // gradient start point
          end: Alignment.bottomRight,  // gradient end point
          colors: [
            Color.fromARGB(255, 32, 64, 192),               // start color
            Color.fromARGB(255, 104, 129, 255),              // end color
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            text: job["title"], 
            style: AppText.textLight.merge(AppText.fontExtraBold).merge(AppText.textTxl),
          ),
          const SizedBox(height: 5),
          Text(
            job["company"], 
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
              _iconText(Icons.location_on, job["location"]),
              _iconText(Icons.monetization_on, formatToPeso(job["salary"])),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _iconText(Icons.work, job["type"]),
              _iconText(
                Icons.calendar_month,
                DateFormat("MMM d, y")
                    .format(DateTime.parse(job["posted_on"])),
              ),
            ],
          ),
          const SizedBox(height: 10),
          claims['role'] == 'admin'
            ? const SizedBox.shrink() // 👈 Return nothing (empty widget)
          : claims['role'] == 'employer'
            ? AppButton(
                label: 'Update Job',
                onPressed: () => navigateTo(context, EditJob(job: job)),
                backgroundColor: AppColor.light,
                foregroundColor: AppColor.dark,
                visualDensityY: -2,
              )
            : Row(
                children: [
                  isSaved
                      ? AppButton(
                          label: 'Unsave Job',
                          backgroundColor: AppColor.warning,
                          foregroundColor: AppColor.dark,
                          visualDensityY: -2,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AppModal(
                                title: 'Remove saved job?',
                                message:
                                    'Do you want to remove ${job["title"]} from your saved jobs?',
                                confirmLabel: 'Unsave',
                                confirmBackground: AppColor.warning,
                                confirmForeground: AppColor.dark,
                                onConfirm: toggleSaveJob,
                              ),
                            );
                          },
                        )
                      : AppButton(
                          label: 'Save Job',
                          foregroundColor: AppColor.dark,
                          backgroundColor: AppColor.light,
                          visualDensityY: -2,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AppModal(
                                title: 'Save job ${job["title"]}?',
                                message:
                                    'Save ${job["title"]} at ${job["location"]} for later review.',
                                confirmLabel: 'Save Job',
                                confirmBackground: AppColor.primary,
                                confirmForeground: AppColor.light,
                                onConfirm: toggleSaveJob,
                              ),
                            );
                          },
                        ),

                  const SizedBox(width: 10),
                  isApplied
                      ? AppButton(
                          label: 'Applied',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AppModal(
                                  title:
                                      'Are you sure to unapply for job ${job["title"]} at ${job["location"]}',
                                  titleStyle:
                                      AppText.fontSemibold.merge(AppText.textLg),
                                  confirmLabel: "Unapply",
                                  confirmBackground: AppColor.primary,
                                  confirmForeground: AppColor.light,
                                  onConfirm: unapplyJob,
                                );
                              },
                            );
                          },
                          backgroundColor: AppColor.success,
                          foregroundColor: AppColor.light,
                          visualDensityY: -2,
                        )
                      : AppButton(
                          label: 'Apply Job',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AppModal(
                                  title:
                                      'Apply for ${job["title"]} at ${job["location"]}',
                                  titleStyle:
                                      AppText.fontSemibold.merge(AppText.textLg),
                                  message:
                                      'You\'re about to apply for: ${job["title"]} at ${job["location"]}. Your information will be shared with the employer.',
                                  confirmLabel: "Apply",
                                  confirmBackground: AppColor.primary,
                                  confirmForeground: AppColor.light,
                                  onConfirm: applyJob,
                                );
                              },
                            );
                          },
                          foregroundColor: AppColor.dark,
                          backgroundColor: AppColor.light,
                          visualDensityY: -2,
                        ),
                ],
              )
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
  final List<String> jobSkills;

  const JobDescriptionCard({
    super.key,
    required this.description,
    required this.jobSkills,
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
              Text(description),
              const SizedBox(height: 10),
              Text("Required Skills", style: AppText.textMd.merge(AppText.fontSemibold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < jobSkills.length; i += 2)
                    Row(
                      children: [
                        for (int j = i; j < i + 2 && j < jobSkills.length; j++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: AppBadge(
                              text: jobSkills[j],
                              backgroundColor: AppColor.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobDetailsCard extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailsCard({
    super.key,
    required this.job
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
                    child: Text(job["type"]),
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
                    child: Text(formatToPeso(job["salary"])),
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
                    child: Text(job["location"]),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Required Education:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(job["required_education"] ?? "N/A"),
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
                    child: Text(DateFormat("MMM d, y").format(DateTime.parse(job["posted_on"])).toString()),
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
              //       child: Text(job["visibility"]),
              //     )
              //   ],
              // ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Job Status:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(job["status"]),
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
  final Map<String, dynamic> job;

  const AboutCompanyCard({
    super.key,
    required this.claims,
    required this.job
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
              Center(child: Text(job["full_name"], style: AppText.textMd.merge(AppText.fontSemibold))),
              Center(child: Text("Employer", style: AppText.textSm.merge(AppText.fontSemibold).merge(AppText.textSecondary))),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail, size: 20, color: AppColor.primary),
                  const SizedBox(width: 5),
                  Text(job["email"], style: AppText.textSm)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 20, color: AppColor.primary),
                  const SizedBox(width: 5),
                  Text(job["contact"], style: AppText.textSm)
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
                  onPressed: () => navigateTo(context, Messages(user: claims, otherUserId: job['employer_id'])),
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