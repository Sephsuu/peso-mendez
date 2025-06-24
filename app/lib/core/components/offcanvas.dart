import 'package:app/core/components/button.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

import 'package:app/features/homepage.dart';

import 'package:app/core/theme/typography.dart';

class OffcanvasNavigation extends StatelessWidget {
  const OffcanvasNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      width: screenWidth * 0.7,
      child: Container(
        margin: EdgeInsets.only(top: screenHeight * 0.2),
        child: Column(
          children: [
            GestureDetector(
              child: Text('Home', style: AppText.textMd.merge(AppText.fontSemibold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(onNavigate: (page) => globalNavigateTo?.call(page)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20), 
            GestureDetector(
              child: Text('About', style: AppText.textMd.merge(AppText.fontSemibold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(onNavigate: (page) => globalNavigateTo?.call(page)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20), 
            GestureDetector(
              child: Text('Job Listing', style: AppText.textMd.merge(AppText.fontSemibold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(onNavigate: (page) => globalNavigateTo?.call(page)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20), 
            GestureDetector(
              child: Text('Career Hub', style: AppText.textMd.merge(AppText.fontSemibold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(onNavigate: (page) => globalNavigateTo?.call(page)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20), 
            GestureDetector(
              child: Text('Contact', style: AppText.textMd.merge(AppText.fontSemibold)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(onNavigate: (page) => globalNavigateTo?.call(page)),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const SignInOrRegisterButton(),
          ],
        ),
      )
    );
  }
}