import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class DashboardSummaryCard extends StatelessWidget {
  final String header;
  final String count;
  final Color color;

  const DashboardSummaryCard({
    super.key,
    required this.header,
    required this.count,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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