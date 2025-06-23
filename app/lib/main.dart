import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/style/typography.dart';

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
      body: HomepageJumbotron(),
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Find Jobs Near Mendez, Cavite",
            style: AppText.textLg.merge(AppText.fontBold).merge(AppText.textPrimary),
            
          )
        ],
      ),
    );
  }
}