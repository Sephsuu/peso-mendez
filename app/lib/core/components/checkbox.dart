import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final String label;
  final bool state;
  final ValueChanged<bool?>? onChanged;
  final TextStyle? textStyle; 

  const AppCheckbox({
    super.key,
    required this.label,
    required this.state,
    this.onChanged,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,                
      controlAffinity: ListTileControlAffinity.leading, 
      title: Text(label, style: textStyle),
      value: state,
      onChanged: onChanged,
    );
  }
}