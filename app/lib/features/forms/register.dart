import 'package:app/features/forms/credentials_form.dart';
import 'package:app/features/forms/personal_information_form.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';

import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/footer.dart';

class Register extends StatefulWidget {
  final Function(PageType) onNavigate;

  const Register({super.key, required this.onNavigate });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int activeForm = 0;

  void _toggleContent(int section) {
    setState(() {
      activeForm = section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            activeForm == 0 ? RegisterForm(onNext: () => _toggleContent(1)) : activeForm == 1 ? const PersonalInformationForm() : const Footer(),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
