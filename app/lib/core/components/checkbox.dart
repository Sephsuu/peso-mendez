import 'package:flutter/material.dart';

class AppCheckbox extends StatelessWidget {
  final String label;
  final bool state;
  final ValueChanged<bool?> onChanged;

  const AppCheckbox({
    super.key,
    required this.label,
    required this.state,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,                
      controlAffinity: ListTileControlAffinity.leading, 
      title: Text(label),
      value: state,
      onChanged: onChanged,
    );
  }
}