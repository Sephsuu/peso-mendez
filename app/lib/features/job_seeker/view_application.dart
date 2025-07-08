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
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ViewApplicationCover(application: application)
              ],
            ),
          ),
          const Footer()
        ],
      )
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
              const SizedBox(width: 40),
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
              const SizedBox(width: 40),
              const Icon(Icons.calendar_month, size: 20.0, color: Colors.white),
              const SizedBox(width: 10),
              Text(DateFormat("MMM d, y").format(DateTime.parse(application["posted_on"])).toString(), style: AppText.textLight.merge(AppText.textMd)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                child: Row(
                  children: [
                    Icon(Icons.bookmark, size: 20.0, color: Colors.black),
                    const SizedBox(width: 5),
                    Text("Save Job")
                  ],
                )
              ),
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
