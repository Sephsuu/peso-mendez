import 'package:flutter/material.dart';
import 'package:app/features/forms/register.dart';

Future<void> main() async {
  // 🩵 This must come BEFORE runApp
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const MainScreen(),
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
    globalNavigateTo = _navigateTo;
  }

  @override
  void dispose() {
    globalNavigateTo = null;
    super.dispose();
  }

  Widget _getPage() {
    switch (_currentPage) {
      case PageType.home:
      case PageType.register:
      case PageType.login:
      case PageType.jobSeekerDashboard:
      case PageType.jobSeekerEditProfile:
      case PageType.employerDashboard:
        return const Register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(),
    );
  }
}
