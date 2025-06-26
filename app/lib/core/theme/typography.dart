import 'package:flutter/material.dart';

class FontSizes {
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
  static const double dxl = 22.0;
  static const double txl = 24.0;
  static const double fxl = 26.0;
}

class TextColors {
  static const Color primary = Color(0xFF0d6efd);
  static const Color secondary = Color(0xFF6c757d);
  static const Color success = Color(0xFF198754);
  static const Color danger = Color(0xFFdc3545);
  static const Color warning = Color(0xFFffc107);
  static const Color info = Color(0xFF0dcaf0);
  static const Color light = Color(0xFFf8f9fa);
  static const Color dark = Color(0xFF212529);
  static const Color muted = Color(0xFF6c757d);
}

class AppText {
  static TextStyle get textXs => const TextStyle(fontSize: FontSizes.xs);
  static TextStyle get textSm => const TextStyle(fontSize: FontSizes.sm);
  static TextStyle get textMd => const TextStyle(fontSize: FontSizes.md);
  static TextStyle get textLg => const TextStyle(fontSize: FontSizes.lg);
  static TextStyle get textXl => const TextStyle(fontSize: FontSizes.xl);
  static TextStyle get textDxl => const TextStyle(fontSize: FontSizes.dxl);
  static TextStyle get textTxl => const TextStyle(fontSize: FontSizes.txl);
  static TextStyle get textFxl => const TextStyle(fontSize: FontSizes.fxl);

  static TextStyle get textPrimary => const TextStyle(color: TextColors.primary);
  static TextStyle get textSecondary => const TextStyle(color: TextColors.secondary);
  static TextStyle get textSuccess => const TextStyle(color: TextColors.success);
  static TextStyle get textDanger => const TextStyle(color: TextColors.danger);
  static TextStyle get textWarning => const TextStyle(color: TextColors.warning);
  static TextStyle get textInfo => const TextStyle(color: TextColors.info);
  static TextStyle get textLight => const TextStyle(color: TextColors.light);
  static TextStyle get textDark => const TextStyle(color: TextColors.dark);
  static TextStyle get textMuted => const TextStyle(color: TextColors.muted);


  static TextStyle get fontThin => const TextStyle(fontWeight: FontWeight.w100);
  static TextStyle get fontExtraLight => const TextStyle(fontWeight: FontWeight.w200);
  static TextStyle get fontLight => const TextStyle(fontWeight: FontWeight.w300);
  static TextStyle get fontRegular => const TextStyle(fontWeight: FontWeight.w400);
  static TextStyle get fontMedium => const TextStyle(fontWeight: FontWeight.w500);
  static TextStyle get fontSemibold => const TextStyle(fontWeight: FontWeight.w600);
  static TextStyle get fontBold => const TextStyle(fontWeight: FontWeight.w700);
  static TextStyle get fontExtraBold => const TextStyle(fontWeight: FontWeight.w800);
  static TextStyle get fontBlack => const TextStyle(fontWeight: FontWeight.w900);
}

