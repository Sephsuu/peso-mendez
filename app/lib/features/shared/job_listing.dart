import 'package:app/core/components/alert.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/features/dashboard/admin.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:app/features/forms/login.dart';
import 'package:app/features/job_seeker/view_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/loader.dart';


import 'package:app/core/theme/typography.dart';
import 'package:app/core/theme/colors.dart';

const jobOptions = ['Featured Jobs', 'Recommended Jobs'];
const caviteLocations = ["All Locations","Alfonso","Amadeo","Bacoor City","Carmona","Cavite City","Cavite Province","City of General Trias","Dasmariñas City","General Emilio Aguinaldo","General Mariano Alvarez","Imus City","Indang","Kawit","Magallanes","Maragondon","Mendez","Naic","Noveleta","Rosario","Silang","Tagaytay City","Tanza","Ternate","Trece Martires City"];

class JobListing extends HookWidget {
  const JobListing({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final activeJobs = useState(jobOptions[0]);
    final loading = useState(false);
    final find = useState("");
    final type = useState("All Jobs");
    final citmun = useState(caviteLocations[0]);
    final minSalary = useState(0);
    final maxSalary = useState(0);
    final jobs = useState<List<Map<String, dynamic>>>([]);
    final filteredJobs = useState<List<Map<String, dynamic>>>([]);

    void setFind(String newVal) {
      find.value = newVal;
    }

    void setType(String newVal) {
      type.value = newVal;
    }

    void setCitmun(String newVal) {
      citmun.value = newVal;
    }

    void setMinSalary(int newVal) {
      minSalary.value = newVal;
    }

    void setMaxSalary(int newVal) {
      maxSalary.value = newVal;
    }

    // Fetch all jobs
    useEffect(() {
      void fetchData() async {
        loading.value = true; 
        try {
          if (activeJobs.value == jobOptions[0]) {
            final data = await JobService.getAllJobs();
            jobs.value = data;
          } else {
            final data = await JobService.getRecommendedJobs(claims['id']);
            jobs.value = data;
          }
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to load jobs.");
        } finally { loading.value = false; }
      }
      fetchData();
      return null;
    }, [activeJobs.value]);
    
    // Filter all jobs depending on find search
    useEffect(() {
      if (find.value.isEmpty) {
        filteredJobs.value = jobs.value;
      } else {
        filteredJobs.value = jobs.value.where((job) {
          final title = job["title"]?.toLowerCase() ?? '';
          return title.contains(find.value.toLowerCase());
        }).toList();
      }
      return null;
    }, [find.value, jobs.value]);

    useEffect(() {
      loading.value = true;

      List<Map<String, dynamic>> temp = jobs.value;

      if (find.value.isNotEmpty) {
        temp = temp.where((job) {
          final title = job["title"]?.toLowerCase() ?? '';
          return title.contains(find.value.toLowerCase());
        }).toList();
      }

      if (type.value == "Full-Time" || type.value == "Part-Time") {
        temp = temp.where((job) => job["type"] == type.value).toList();
      }

      if (citmun.value != "All Locations") {
        temp = temp.where((job) => job["citmun"] == citmun.value).toList();
      }

      if (!(minSalary.value == 0 && maxSalary.value == 0)) {
        temp = temp.where((job) {
          final salary = job["salary"] ?? 0; // numeric assumed
          return salary >= minSalary.value && salary <= maxSalary.value;
        }).toList();
      }

      filteredJobs.value = temp;

      loading.value = false;
      return null;
    }, [
      find.value,
      type.value,
      citmun.value,
      minSalary.value,
      maxSalary.value,
      jobs.value
    ]);


    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez Peso Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: RefreshIndicator(
        onRefresh: AppLoader.handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: jobOptions.map((item) {
                  return AppButton(
                    label: item,
                    onPressed: () { activeJobs.value = item; },
                    disableShadow: true,
                    backgroundColor: Colors.transparent,
                    foregroundColor: activeJobs.value != item ? AppColor.muted : AppColor.primary,
                  );
                }).toList()
              ),
              Align(
                alignment: Alignment.topCenter,
                child: HomepageJumbotron(
                  claims: claims,
                  setFind: setFind, 
                  type: type.value,
                  setType: setType,
                  citmun: citmun.value,
                  setCitmun: setCitmun,
                  setMinSalary: setMinSalary,
                  setMaxSalary: setMaxSalary,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                activeJobs.value == jobOptions[0] ? 'Featured Local Jobs' : 'Jobs Matching My Skills',
                style: AppText.textXl.merge(AppText.fontBold)
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  child: JobList(
                    claims: claims,
                    jobs: filteredJobs.value,
                    loading: loading.value,
                  )
                ),
              ),
              const Footer()
            ],
          ),
        ),
      ),
    );
  }
}

class HomepageJumbotron extends StatelessWidget {
  final Map<String, dynamic> claims;
  final ValueChanged<String> setFind;
  final ValueChanged<String> setType;
  final String type;
  final ValueChanged<String> setCitmun;
  final String citmun;
  final ValueChanged<int> setMinSalary;
  final ValueChanged<int> setMaxSalary;

  const HomepageJumbotron({
    super.key, 
    required this.claims,
    required this.setFind,
    required this.type,
    required this.setType,
    required this.citmun,
    required this.setCitmun,
    required this.setMinSalary,
    required this.setMaxSalary
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final List<String> jobTypes = ['All Jobs', 'Full-Time', 'Part-Time'];

    return Container(
      color: const Color.fromARGB(255, 228, 233, 255),
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "Find Jobs Near Mendez, Cavite",
            style: AppText.textLg.merge(AppText.fontSemibold).merge(AppText.textDark),
            
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: screenWidth * 0.8,
            child: TextField(
              style: AppText.textXs,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.light,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                labelText: 'Job title, keywords, or company',
                labelStyle: AppText.textSm,
                border: const OutlineInputBorder()
              ),
              onChanged: (value) => setFind(value),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: screenWidth * 0.8,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppSelect(
                    hideIcon: true,
                    textSize: 12,
                    items: jobTypes,
                    value: type,
                    onChanged: (value) {
                      if (value != null) setType(value);
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 4,
                  child: AppSelect(
                    hideIcon: true,
                    textSize: 12,
                    items: caviteLocations,
                    value: citmun,
                    onChanged: (value) {
                      if (value != null) setCitmun(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: screenWidth * 0.8,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AppInputField(
                    label: "Min Salary",
                    textSize: 12,
                    visualDensityY: -2,
                    onChanged: (value) {
                      int newVal = int.tryParse(value) ?? 0;
                      setMinSalary(newVal);
                    },
                    numericOnly: true,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: AppInputField(
                    label: "Max Salary",
                    textSize: 12,
                    visualDensityY: -2,
                    onChanged: (value) {
                      int newVal = int.tryParse(value) ?? 0;
                      setMaxSalary(newVal);
                    },
                    numericOnly: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: claims.isNotEmpty ? 'View Profile' : 'Sign In Now', 
            foregroundColor: AppColor.light,
            visualDensityY: -2,
            onPressed: claims.isNotEmpty ? (
              () => claims['role'] == 'employer' ? (
                navigateTo(context, const EmployerDashboard())) 
                : claims['role'] == 'job_seeker' ? (
                  navigateTo(context, const JobSeekerDashboard())) 
                : claims['role'] == 'admin' ? (navigateTo(context, const AdminDashboard())) 
                : AppModal(
                  title: 'Session expired. Please re-log in.',
                  onConfirm: () => navigateTo(context, const Login()),
                )
            ) : () => navigateTo(context, const Login())
          )
        ],
      ),
    );
  }
}

class JobList extends StatelessWidget {
  final Map<String, dynamic> claims;
  final List<Map<String, dynamic>> jobs;
  final bool loading; 

  const JobList({
    super.key,
    required this.claims,
    required this.jobs,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const Loader();
    if (jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.work_outline, size: 48, color: AppColor.muted),
              const SizedBox(height: 12),
              Text(
                "No jobs found",
                style: AppText.textMd.merge(AppText.fontSemibold),
              ),
              const SizedBox(height: 6),
              Text(
                "Try adjusting your filters or check back later.",
                style: AppText.textMuted.merge(AppText.textSm),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromARGB(255, 223, 223, 223),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job["title"],
                    style: AppText.textMd.merge(AppText.fontSemibold)),
                const SizedBox(height: 12.0),
                Text(job["company"],
                    style:
                        AppText.textSecondary.merge(AppText.fontSemibold)),
                const SizedBox(height: 8.0),
                Text("📍 ${job["citmun"]}",
                    style: AppText.textMuted.merge(AppText.textXs)),
                const SizedBox(height: 8.0),
                Text(
                  "💰 ${formatToPeso(job["salary"])} • ${job["company"]}",
                  style: AppText.textPrimary
                      .merge(const TextStyle(fontSize: 13))
                      .merge(AppText.fontSemibold),
                ),
                const SizedBox(height: 15.0),
                AppButton(
                  label: 'View Details',
                  onPressed: claims['role'] == 'job_seeker' ||
                          claims['role'] == 'admin'
                      ? () => navigateTo(context, ViewJob(jobId: job['id']))
                      : claims['role'] == 'employer'
                          ? () => showDialog(
                                context: context,
                                builder: (context) {
                                  return AppModal(
                                    title:
                                        "You cannot apply for this job because you're an employer at PESO Mendez",
                                    titleStyle: AppText.fontSemibold
                                        .merge(AppText.textLg),
                                    confirmLabel: "I understand.",
                                    confirmBackground: AppColor.primary,
                                    confirmForeground: AppColor.light,
                                  );
                                },
                              )
                          : () => navigateTo(context, const Login()),
                  foregroundColor: AppColor.light,
                  visualDensityY: -1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
