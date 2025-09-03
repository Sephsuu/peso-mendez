import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double? fontSize;
  final Color? fontColor;

  const AppBadge({
    super.key,
    required this.text,
    required this.color,
    this.borderRadius,
    this.padding = const EdgeInsets.all(2),
    this.child,
    this.fontSize = 12,
    this.fontColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius ?? 4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fontColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}