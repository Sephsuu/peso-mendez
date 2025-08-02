import 'package:app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppLoader {
  static Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
class Loader extends StatelessWidget {
  const Loader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 40), child: const CircularProgressIndicator(color: AppColor.info));
  }
}