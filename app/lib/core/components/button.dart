import 'package:flutter/material.dart';

import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';

class HomepageFindButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("Pressed");
      }, 
      child: const Text('Find Job'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)
        )
      ),
    );
  }
}