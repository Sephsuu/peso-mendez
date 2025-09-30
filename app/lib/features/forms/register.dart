import 'package:app/features/forms/credentials_form.dart';
import 'package:flutter/material.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/footer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int activeForm = 0;

  // void _toggleContent(int section) {
  //   setState(() {
  //     activeForm = section;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            RegisterForm(),
            Footer(),
          ],
        ),
      ),
    );
  }
}
