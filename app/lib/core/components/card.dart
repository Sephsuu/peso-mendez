import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class DashboardSummaryCard extends StatelessWidget {
  final String header;
  final String count;
  final Color color;
  final Widget onTap;

  const DashboardSummaryCard({
    super.key,
    required this.header,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => onTap));
        },
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(header, style: AppText.textLight.merge(AppText.fontSemibold)),
                const SizedBox(height: 3),
                Text(count, style: AppText.textLight.merge(AppText.textFxl)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardOtherContentCard extends StatelessWidget {
  final String header;
  final String paragraph;
  final Widget button;

  const DashboardOtherContentCard({
    super.key,
    required this.header,
    required this.paragraph,
    required this.button
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(header, style: AppText.fontSemibold),
              const SizedBox(height: 5),
              Text(paragraph),
              const SizedBox(height: 8),
              button
            ],
          ),    
        ),
      ),
    );
  }
}

class AdminSummaryCard extends StatelessWidget {
  final Color color;
  final String text;
  final String count;
  final VoidCallback navigateTo;

  const AdminSummaryCard({
    super.key,
    required this.color,
    required this.text,
    required this.count,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateTo,
      child: Card(
        color: Colors.white, // ✅ light background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          // side: BorderSide(color: color.withOpacity(0.6), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: AppText.textXs.merge(AppText.fontSemibold).copyWith(
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                count,
                textAlign: TextAlign.center,
                style: AppText.textFxl.merge(AppText.fontSemibold).copyWith(
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

