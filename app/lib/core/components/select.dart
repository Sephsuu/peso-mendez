import 'package:flutter/material.dart';

import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';

class HomepageDropdownSelect extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const HomepageDropdownSelect({
    Key? key,
    required this.items,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _HomepageDropdownSelectState createState() => _HomepageDropdownSelectState();
}

class _HomepageDropdownSelectState extends State<HomepageDropdownSelect> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.light,
        border: Border.all(color: AppColor.muted, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton(
        value: selectedValue,
        hint: const Text('Job Type'),
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(), 
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
        },
        isDense: true,
        underline: const SizedBox(),
        style: AppText.textSm.merge(AppText.fontSemibold).merge(AppText.textDark),
      ),
    );
  }
}