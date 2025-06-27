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

class PostNewJobDrowdownSelectRequired extends StatefulWidget {
  String? initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String placeholder;
  final String label;

  PostNewJobDrowdownSelectRequired({
    super.key,
    required this.items,
    this.initialValue,
    required this.placeholder,
    required this.onChanged,
    required this.label,
  });

  @override
  _PostNewJobDrowdownSelectRequiredState createState() => _PostNewJobDrowdownSelectRequiredState();
}
class _PostNewJobDrowdownSelectRequiredState extends State<PostNewJobDrowdownSelectRequired> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, textAlign: TextAlign.start, style: AppText.textSm),
        const SizedBox(height: 7.0),
        DropdownButtonFormField<String>(
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
          items: widget.items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
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
        )
      ],
    );
  }
}

class ViewApplicationDropdownSelect extends StatefulWidget {
  String? initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String placeholder;

  ViewApplicationDropdownSelect({
    super.key,
    required this.items,
    this.initialValue,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  _ViewApplicationDropdownSelectState createState() => _ViewApplicationDropdownSelectState();
}
class _ViewApplicationDropdownSelectState extends State<ViewApplicationDropdownSelect> {
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


// RegisterDrowdownSelect(items: isOfw, initialValue: _isOfw, placeholder: 'Are you an OFW', onChanged: (value) { setState(() { _isOfw = value; }); }),