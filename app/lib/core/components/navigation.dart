import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/core/theme/typography.dart';

class AppNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function(BuildContext) onMenuPressed;

  AppNavigationBar({
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
          Builder(
            builder: (context) => IconButton(
              onPressed: () => onMenuPressed(context),  // Use inner context here
              icon: SvgPicture.asset(
                'assets/icons/sidebar_icon.svg',
                height: 20,
                width: 20,
              ),
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