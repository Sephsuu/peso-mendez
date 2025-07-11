import 'package:app/core/components/modal.dart';
import 'package:app/core/services/application_service.dart';
import 'package:flutter/material.dart';

import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';

class HomepageDropdownSelect extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const HomepageDropdownSelect({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _HomepageDropdownSelectState createState() => _HomepageDropdownSelectState();
}
class _HomepageDropdownSelectState extends State<HomepageDropdownSelect> {
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
        value: widget.initialValue,
        hint: const Text('Job Type'),
        items: widget.items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(), 
        onChanged: (value) {
          if (value != null) {
            widget.onChanged(value);
          }
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

class ViewApplicationDropdownSelect extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final List<String> items;
  final String initialValue;

  const ViewApplicationDropdownSelect({
    super.key,
    required this.items,
    required this.onChanged,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
        ),
      ),
      value: initialValue,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) => {
        if (value != null) {
          onChanged(value)
        }
      },
    );
  }
}

class ViewApplicationUpdateStatus extends StatefulWidget {
  final String initialValue;
  final int applicationId;

  ViewApplicationUpdateStatus({
    super.key,
    required this.initialValue,
    required this.applicationId
  });

  @override
  _ViewApplicationUpdateStatusState createState() => _ViewApplicationUpdateStatusState();
}
class _ViewApplicationUpdateStatusState extends State<ViewApplicationUpdateStatus> {
  List<String> items = ["Sent", "Reviewed", "Interview", "Rejected", "Hired"];
  
  String? selectedValue;
  Key dropdownKey = UniqueKey(); // Add this key
  
  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }
  
  void _updateApplicationStatus(status) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Status successfully updated")));
      await ApplicationService.updateApplicationStatus(widget.applicationId, status);
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: dropdownKey,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        border: OutlineInputBorder(),
      ),
      value: selectedValue,
      items: items.map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (String? newValue) async {
        setState(() {
          dropdownKey = UniqueKey(); 
        });
        
        final result = await updateApplicationStatusModal(context, newValue);
        
        if (result != null && result.isNotEmpty) {
          setState(() {
            selectedValue = result;
            _updateApplicationStatus(selectedValue);
            dropdownKey = UniqueKey();
          });
        }
      },
    );
  }
}

// RegisterDrowdownSelect(items: isOfw, initialValue: _isOfw, placeholder: 'Are you an OFW', onChanged: (value) { setState(() { _isOfw = value; }); }),