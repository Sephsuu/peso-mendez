import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/theme/typography.dart';

class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function(BuildContext) onMenuPressed;

  const AppNavigationBar({super.key, 
    required this.title,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              title,
              style: AppText.fontBold.merge(AppText.textPrimary).merge(AppText.textSm),
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}