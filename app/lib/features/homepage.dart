import 'dart:convert';

import 'package:app/main.dart';
import 'package:flutter/material.dart';

import 'package:app/models/job.dart';

import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/select.dart';

import 'package:app/core/theme/typography.dart';
import 'package:app/core/theme/colors.dart';
import 'package:flutter/services.dart';


class Homepage extends StatelessWidget {
  final Function(PageType) onNavigate;

  Homepage({ required this.onNavigate });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez Peso Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      drawer: OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: HomepageJumbotron(),
            ),
            const SizedBox(height: 10.0),
            Text('Featured Local Jobs', style: AppText.textXl.merge(AppText.fontBold)),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                  child: FeaturedJobs(),
                ),
              ),
            ),
            Footer()
          ],
        ),
      ),
    );
  }
}

class HomepageJumbotron extends StatelessWidget {
  final List<String> jobTypes = ['Full-time', 'Part-time'];

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
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                labelText: 'Job title, keywords, or company',
                labelStyle: AppText.textSm,
                border: const OutlineInputBorder()
              ),
              onChanged: (value) => {
                print('User typed: $value')
              },
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
                contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
              HomepageDropdownSelect(items: jobTypes, initialValue: null),
              const SizedBox(width: 10),
              HomepageFindButton(),
            ],
          ),
          const SizedBox(height: 12),
          HomepageRegisterButton()
        ],
      ),
    );
  }
}

class FeaturedJobs extends StatefulWidget {
  @override
  _FeaturedJobsState createState() => _FeaturedJobsState();
}

class _FeaturedJobsState extends State<FeaturedJobs> {
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  Future<void> loadJobs() async {
    final String response = await rootBundle.loadString('assets/mocks/jobs.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      jobs = data.map((json) => Job.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      shrinkWrap: true,
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
                Text(job.title, style: AppText.textMd.merge(AppText.fontSemibold)),
                const SizedBox(height: 12.0),
                Text(job.company, style: AppText.textSecondary.merge(AppText.fontSemibold)),
                const SizedBox(height: 8.0),
                Text("📍 ${job.location}", style: AppText.textMuted.merge(AppText.textXs)),
                const SizedBox(height: 8.0),
                Text("💰 ${job.salary} • ${job.company}", style: AppText.textPrimary.merge(const TextStyle(fontSize: 13)).merge(AppText.fontSemibold)),
                const SizedBox(height: 15.0),
                FeaturedJobsButton(),
              ],
            ),
          )
        );
      },
    );
  }

}