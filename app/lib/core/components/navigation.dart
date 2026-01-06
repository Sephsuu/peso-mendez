import 'package:flutter/material.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/images/peso-mendez.png', width: 50),
          const SizedBox(width: 10),
          Center(
            child: Text(
              title == 'Mendez Peso Job Portal'
                  ? title
                  : 'PESO Jobs-Mendez',
              style: AppText.fontBold
                  .merge(AppText.textPrimary)
                  .merge(AppText.textSm),
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

void navigateTo(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}