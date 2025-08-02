import 'package:app/core/components/footer.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class ViewApplication extends HookWidget {
  final Function(PageType) onNavigate;
  final Map<String, dynamic> application;

  const ViewApplication({
    super.key,
    required this.onNavigate,
    required this.application
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ViewApplicationCover(application: application),
            JobDescriptionCard(description: application["description"]),
            JobDetailsCard(application: application),
            AboutCompanyCard(application: application),
            const Footer()
          ],
        ),
      ),
    );
  }
}

class ViewApplicationCover extends StatelessWidget {
  final Map<String, dynamic> application;
  
  const ViewApplicationCover({
    super.key,
    required this.application,
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
          Text(application["title"], style: AppText.textLight.merge(AppText.fontExtraBold).merge(AppText.textTxl)),
          const SizedBox(height: 5),
          Text(application["company"], style: AppText.textLight.merge(AppText.fontSemibold).merge(AppText.textXl)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on, size: 20.0, color: Colors.white),
              const SizedBox(width: 10),
              Text(application["location"], style: AppText.textLight.merge(AppText.textMd)),
              const SizedBox(width: 20),
              const Icon(Icons.monetization_on, size: 20.0, color: Colors.white),
              const SizedBox(width: 10),
              Text(application["salary"], style: AppText.textLight.merge(AppText.textMd)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.work, size: 20.0, color: Colors.white),
              const SizedBox(width: 10),
              Text(application["type"], style: AppText.textLight.merge(AppText.textMd)),
              const SizedBox(width: 20),
              const Icon(Icons.calendar_month, size: 20.0, color: Colors.white),
              const SizedBox(width: 10),
              Text(DateFormat("MMM d, y").format(DateTime.parse(application["posted_on"])).toString(), style: AppText.textLight.merge(AppText.textMd)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.light,
                  foregroundColor: AppColor.dark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  )
                ),
                onPressed: () {}, 
                child: const Row(
                  children: [
                    Icon(Icons.bookmark, size: 20.0, color: Colors.black),
                    SizedBox(width: 5),
                    Text("Save Job")
                  ],
                )
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.success,
                  foregroundColor: AppColor.light,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  )
                ),
                onPressed: () {}, 
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 20.0, color: Colors.white),
                    const SizedBox(width: 5),
                    Text("Applied")
                  ],
                )
              ),
            ],
          ),
        ],
      ),
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
                  Icon(Icons.file_copy, size: 20),
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
                  Icon(Icons.info, size: 20),
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
                    child: Text(application["salary"]),
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
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Visibility:", style: AppText.textPrimary.merge(AppText.fontSemibold)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(application["visibility"]),
                  )
                ],
              ),
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
  final Map<String, dynamic> application;

  const AboutCompanyCard({
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
                  Icon(Icons.business, size: 20),
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
                  child: Center(child: Icon(Icons.business, size: 50)),
                ),
              ),
              const SizedBox(height: 15),
              Center(child: Text(application["full_name"], style: AppText.textMd.merge(AppText.fontSemibold))),
              Center(child: Text("Employer", style: AppText.textSm.merge(AppText.fontSemibold).merge(AppText.textSecondary))),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail, size: 20, color: AppColor.primary),
                  const SizedBox(width: 5),
                  Text(application["email"], style: AppText.textSm)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, size: 20, color: AppColor.primary),
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
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mail, size: 20, color: AppColor.light),
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