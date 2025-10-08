import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;
  final bool softWrap;

  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 2,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth - 10),
          child: Text(
            text,
            style: style,
            overflow: overflow,
            softWrap: softWrap,
            maxLines: maxLines,
          ),
        );
      },
    );
  }
}
