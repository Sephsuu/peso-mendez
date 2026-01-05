import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final String text;

  /// 🎨 Colors
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final Color? shadowColor;

  /// 📐 Layout
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double? width;
  final bool isCenter;

  const AppBadge({
    super.key,
    required this.text,

    // 🎨 Defaults (similar to AppButton)
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.shadowColor,

    // 📐 Defaults
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.fontSize = 12,
    this.width,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : null,
        boxShadow: shadowColor != null
            ? [
                BoxShadow(
                  color: shadowColor!,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: foregroundColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return isCenter ? Center(child: badge) : badge;
  }
}
