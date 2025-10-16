import 'package:flutter/material.dart';
import 'package:app/core/theme/typography.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      color: const Color.fromARGB(255, 239, 239, 239),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Column(
        children: [
          Text('© 2025 Mendez PESO Job Portal. All rights reserved.', style: AppText.textSecondary, textAlign: TextAlign.center),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: const Text('Privacy Policy'),
                onTap: () {},
              ),
              GestureDetector(
                child: const Text('Terms of Use'),
                onTap: () {},
              ),
              GestureDetector(
                child: const Text('Contact'),
                onTap: () {},                
              )
            ],
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}