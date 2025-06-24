import 'package:flutter/material.dart';

import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';

class HomepageDropdownSelect extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  const HomepageDropdownSelect({
    super.key,
    required this.items,
    this.initialValue,
    this.onChanged,
  });

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

class RegisterDrowdownSelectRequired extends StatefulWidget {
  String? initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String placeholder;

  RegisterDrowdownSelectRequired({
    super.key,
    required this.items,
    this.initialValue,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  _RegisterDrowdownSelectRequiredState createState() => _RegisterDrowdownSelectRequiredState();
}

class _RegisterDrowdownSelectRequiredState extends State<RegisterDrowdownSelectRequired> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        labelText: widget.placeholder,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
        ),
      ),
      value: selectedValue,
      items: widget.items.map((gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

class RegisterDrowdownSelect extends StatefulWidget {
  String? initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String placeholder;

  RegisterDrowdownSelect({
    super.key,
    required this.items,
    this.initialValue,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  _RegisterDrowdownSelectState createState() => _RegisterDrowdownSelectState();
}

class _RegisterDrowdownSelectState extends State<RegisterDrowdownSelect> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        labelText: widget.placeholder,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
        ),
      ),
      value: selectedValue,
      items: widget.items.map((gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}