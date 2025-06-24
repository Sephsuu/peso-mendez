
import 'package:flutter/material.dart';
import 'package:app/features/homepage.dart';

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
      home: MainScreen()
    
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

enum PageType { home }

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
        return Homepage(onNavigate: _navigateTo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(),
    );
  }
}