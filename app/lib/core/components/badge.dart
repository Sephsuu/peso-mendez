import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final String text;
  final Color color;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double? fontSize;
  final Color? fontColor;
  final double? width;
  final bool isCenter;

  const AppBadge({
    super.key,
    required this.text,
    required this.color,
    this.borderRadius,
    this.padding = const EdgeInsets.all(2),
    this.child,
    this.fontSize = 12,
    this.fontColor = Colors.white,
    this.width,
    this.isCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    return isCenter ? Center(
      child: Container(
        padding: padding,
        width: width ?? width,
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
        )
      ),
    ) : Container(
      padding: padding,
      width: width ?? width,
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
      )
    );
  }
}