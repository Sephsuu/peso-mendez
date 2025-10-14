import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../services/auth_service.dart'; // adjust your path

Map<String, dynamic> useClaimsHook(context) {
  final claims = useState<Map<String, dynamic>>({});

  useEffect(() {
    void fetchData() async {
      try {
        final data = await AuthService.getClaims();
        claims.value = data;
      } catch (e) {
        if (!context.mounted) return;
        showDialog(
          context: context, 
          builder: (context) {
            return AppModal(
              title: 'You need to login in order to use PESO Mendez App.',
              titleStyle: AppText.fontSemibold.merge(AppText.textLg),
              confirmLabel: "Login",
              confirmBackground: AppColor.primary,
              confirmForeground: AppColor.light,
              onConfirm: () => navigateTo(context, const Login()),
            );
          }
        );
      }
    }

    fetchData();
    return null;
  }, []);

  return claims.value;
}
