import 'package:app/core/components/select.dart';
import 'package:app/core/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/core/theme/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PESO Mendez",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationBar(title: 'Mendez Peso Job Portal'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: HomepageJumbotron(),
            ),
          ],
        ),
      )
    );
  }
}

class NavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  NavigationBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Center(
              child: Text(
                title,
                style: AppText.fontBold.merge(AppText.textPrimary).merge(AppText.textSm),
              ),
            )
          ),
          IconButton(
            onPressed: () {
              print("Hello world");
            }, 
            icon: SvgPicture.asset(
              'assets/icons/sidebar_icon.svg',
              height: 20,
              width: 20,
            )
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
          )
        ],
      ),
    );
  }
}