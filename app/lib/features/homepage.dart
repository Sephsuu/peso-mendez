import 'package:app/core/components/alert.dart';
import 'package:app/main.dart';
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


class Homepage extends HookWidget {
  final Function(PageType) onNavigate;

  const Homepage({super.key,  required this.onNavigate });

  @override
  Widget build(BuildContext context) {
    final find = useState("");
    final type = useState("");
    final jobs = useState<List<Map<String, dynamic>>>([]);
    final filteredJobs = useState<List<Map<String, dynamic>>>([]);

    void setFind(String newVal) {
      find.value = newVal;
    }

    void setType(String newVal) {
      type.value = newVal;
    }

    // Fetch all jobs
    useEffect(() {
      void fetchData() async {
        try {
          final data = await JobService.fetchJobs();
          jobs.value = data;
        } catch (e) {
          if (!context.mounted) return;
          showAlertError(context, "Failed to load jobs.");
        }
      }
      fetchData();
      return null;
    }, []);

    filteredJobs.value = jobs.value;

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
    }, [find.value]);

    // Filter jobs depending on type
    useEffect(() {
      if (type.value == "Full-time") {
        filteredJobs.value = jobs.value.where((job) {
          return job["type"] == "Full-time";
        }).toList();
      } else if (type.value == "Part-time") {
        filteredJobs.value = jobs.value.where((job) {
          return job["type"] == "Part-time";
        }).toList();
      } else {
        filteredJobs.value = jobs.value;
      }
      return null;
    }, [type.value]);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez Peso Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: RefreshIndicator(
        onRefresh: AppLoader.handleRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: HomepageJumbotron(setFind: setFind, setType: setType),
              ),
              const SizedBox(height: 10.0),
              Text('Featured Local Jobs', style: AppText.textXl.merge(AppText.fontBold)),
              const SizedBox(height: 10.0),
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  child: FeaturedJobs(jobs: filteredJobs.value)
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
  final ValueChanged<String> setFind;
  final ValueChanged<String> setType;
  final List<String> jobTypes = ['All Jobs', 'Full-time', 'Part-time'];

  HomepageJumbotron({
    super.key, 
    required this.setFind,
    required this.setType
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
            width: screenWidth * 0.5,
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
          const SizedBox(height: 10,),
          SizedBox(
            width: screenWidth * 0.5,
            child: TextField(
              style: AppText.textXs,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Mendez, Cavite',
                labelStyle: AppText.textSm,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                filled: true,
                fillColor: AppColor.light,
                border: const OutlineInputBorder()
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomepageDropdownSelect(items: jobTypes, initialValue: "All Jobs", onChanged: setType),
              const SizedBox(width: 10),
              const HomepageFindButton(),
            ],
          ),
          const SizedBox(height: 12),
          const HomepageRegisterButton()
        ],
      ),
    );
  }
}

class FeaturedJobs extends StatelessWidget {
  final List<Map<String, dynamic>> jobs;

  const FeaturedJobs({
    super.key,
    required this.jobs
  });

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Container(padding: const EdgeInsets.symmetric(vertical: 40), child: const CircularProgressIndicator(color: AppColor.info));
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
            side: const BorderSide(color: Color.fromARGB(255, 223, 223, 223), width: 1.0),
            borderRadius: BorderRadius.circular(8)
          ),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(job["title"], style: AppText.textMd.merge(AppText.fontSemibold)),
                const SizedBox(height: 12.0),
                Text(job["company"], style: AppText.textSecondary.merge(AppText.fontSemibold)),
                const SizedBox(height: 8.0),
                Text("📍 ${job["location"]}", style: AppText.textMuted.merge(AppText.textXs)),
                const SizedBox(height: 8.0),
                Text("💰 ${job["salary"]} • ${job["company"]}", style: AppText.textPrimary.merge(const TextStyle(fontSize: 13)).merge(AppText.fontSemibold)),
                const SizedBox(height: 15.0),
                FeaturedJobsButton(jobId: job["id"]),
              ],
            ),
          )
        );
      },
    );
  }
}