import 'package:app/features/forms/educational_background.dart';
import 'package:app/features/forms/job_reference.dart';
import 'package:app/features/forms/language_profeciency.dart';
import 'package:flutter/material.dart';

import 'package:app/features/homepage.dart';
import 'package:app/features/forms/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PESO Mendez",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen()
    
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum PageType { 
  home,
  register,
  login,
  jobSeekerDashboard,
  jobSeekerEditProfile,
  employerDashboard,
}

typedef NavigateToCallback = void Function(PageType page);

NavigateToCallback? globalNavigateTo;

class _MainScreenState extends State<MainScreen> {
  PageType _currentPage = PageType.home;

  void _navigateTo(PageType page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void initState() {
    super.initState();
    globalNavigateTo = _navigateTo; // assign the local function to global variable
  }

  @override
  void dispose() {
    globalNavigateTo = null; // clean up when widget disposed
    super.dispose();
  }

  Widget _getPage() {
    switch (_currentPage) {
      case PageType.home:
        return const EducationalBackgroundForm(userId: 30);
      case PageType.register:
        return Register(onNavigate: _navigateTo);
      case PageType.login:
        return Register(onNavigate: _navigateTo);
      case PageType.jobSeekerDashboard:
        return Register(onNavigate: _navigateTo);
      case PageType.jobSeekerEditProfile:
        return Register(onNavigate: _navigateTo);
      case PageType.employerDashboard:
        return Register(onNavigate: _navigateTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(),
    );
  }
}