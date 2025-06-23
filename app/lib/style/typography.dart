import 'package:flutter/material.dart';

class FontSizes {
  static const double xs = 12.0;
  static const double sm = 14.0;
  static const double md = 16.0;
  static const double lg = 18.0;
  static const double xl = 20.0;
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
  static TextStyle get  textXs => TextStyle(fontSize: FontSizes.xs);
  static TextStyle get textSm => TextStyle(fontSize: FontSizes.sm);
  static TextStyle get textMd => TextStyle(fontSize: FontSizes.md);
  static TextStyle get textLg => TextStyle(fontSize: FontSizes.lg);
  static TextStyle get textXl => TextStyle(fontSize: FontSizes.xl);

  static TextStyle get textPrimary => TextStyle(color: TextColors.primary);
  static TextStyle get textSecondary => TextStyle(color: TextColors.primary);
  static TextStyle get textSuccess => TextStyle(color: TextColors.primary);
  static TextStyle get textDanger => TextStyle(color: TextColors.primary);
  static TextStyle get textWarning => TextStyle(color: TextColors.primary);
  static TextStyle get textPrimary => TextStyle(color: TextColors.primary);
  static TextStyle get textPrimary => TextStyle(color: TextColors.primary);

  static TextStyle get fontThin => TextStyle(fontWeight: FontWeight.w100);
  static TextStyle get fontExtraLight => TextStyle(fontWeight: FontWeight.w200);
  static TextStyle get fontLight => TextStyle(fontWeight: FontWeight.w300);
  static TextStyle get fontRegular => TextStyle(fontWeight: FontWeight.w400);
  static TextStyle get fontMedium => TextStyle(fontWeight: FontWeight.w500);
  static TextStyle get fontSemibold => TextStyle(fontWeight: FontWeight.w600);
  static TextStyle get fontBold => TextStyle(fontWeight: FontWeight.w700);
  static TextStyle get fontExtraBold => TextStyle(fontWeight: FontWeight.w800);
  static TextStyle get fontBlack => TextStyle(fontWeight: FontWeight.w900);
}

