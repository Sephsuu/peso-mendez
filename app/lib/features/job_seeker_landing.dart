import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

class JobSeekerLanding extends StatelessWidget {
  final Function(PageType) onNavigate;

  const JobSeekerLanding({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
    );
  }
}