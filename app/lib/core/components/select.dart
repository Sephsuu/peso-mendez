import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/application_service.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:flutter/material.dart';

import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';

class AppSelect<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String? placeholder;
  final String Function(T)? getLabel;
  final void Function(T?) onChanged;

  final bool isDense;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Color borderColor;
  final Color fillColor;
  final double? width;

  final double textSize;
  final bool hideIcon;

  final bool required;

  // ⭐ NEW: visualDensityY
  final double visualDensityY;

  const AppSelect({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.getLabel,
    this.isDense = true,
    this.borderRadius = 8.0,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
    this.borderColor = const Color.fromARGB(178, 29, 0, 83),
    this.fillColor = Colors.white,
    this.width,
    this.textSize = 14.0,
    this.hideIcon = false,
    this.required = false,

    // ⭐ default same as AppInputField
    this.visualDensityY = -2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        isDense: isDense,
        dropdownColor: fillColor,
        // visualDensity: VisualDensity(vertical: visualDensityY),

        // ⭐ REQUIRED VALIDATOR
        validator: (val) {
          if (required && val == null) {
            return "This field is required";
          }
          return null;
        },

        icon: hideIcon
            ? const SizedBox.shrink()
            : const Icon(Icons.arrow_drop_down),
        iconSize: hideIcon ? 0 : 24,

        decoration: InputDecoration(
          isDense: isDense,
          filled: true,
          fillColor: fillColor,
          labelText: placeholder,
          contentPadding: contentPadding,

          // ⭐ Apply visual density to decoration
          visualDensity: VisualDensity(vertical: visualDensityY),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 1.4),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: Colors.red, width: 1.8),
          ),
        ),

        items: items.map((item) {
          final label = getLabel != null ? getLabel!(item) : item.toString();
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: textSize),
            ),
          );
        }).toList(),

        onChanged: onChanged,
      ),
    );
  }
}

class RegisterDrowdownSelectRequired extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String placeholder;

  const RegisterDrowdownSelectRequired({
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
      initialValue: selectedValue,
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
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String placeholder;

  const RegisterDrowdownSelect({
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
      initialValue: selectedValue,
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

class AppDropdownSelect extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String?> onChanged;
  final List<String> items;
  final String placeholder;
  final String label;

  const AppDropdownSelect({
    super.key,
    required this.items,
    this.initialValue,
    required this.placeholder,
    required this.onChanged,
    required this.label,
  });

  @override
  _AppDropdownSelectState createState() => _AppDropdownSelectState();
}
class _AppDropdownSelectState extends State<AppDropdownSelect> {
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
          initialValue: selectedValue,
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
      initialValue: initialValue,
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
  final Map<String, dynamic> application;
  final VoidCallback setReload;

  const ViewApplicationUpdateStatus({
    super.key,
    required this.initialValue,
    required this.application,
    required this.setReload,
  });

  @override
  State<ViewApplicationUpdateStatus> createState() => _ViewApplicationUpdateStatusState();
}

class _ViewApplicationUpdateStatusState extends State<ViewApplicationUpdateStatus> {
  late String selectedValue;
  final List<String> items = ["Sent", "Reviewed", "Interview", "Rejected", "Hired"];

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue; // ✅ correct initial value
  }

  @override
  void didUpdateWidget(covariant ViewApplicationUpdateStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // ✅ When parent rebuilds (filter applied), update dropdown value correctly
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        selectedValue = widget.initialValue;
      });
    }
  }

  void _updateApplicationStatus(String status) async {
    try {
      await ApplicationService.updateApplicationStatus(widget.application['id'], status);

      await NotificationService.createNotification({
        "userId": widget.application['job_seeker_id'],
        "type": 'APPLICATION STATUS',
        "content": "Application status updated to $status"
      });

      if (!mounted) return;

      widget.setReload();
      AppSnackbar.show(context, message: 'Status updated successfully!', backgroundColor: AppColor.success);

    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: '$e', backgroundColor: AppColor.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        border: OutlineInputBorder(),
      ),
      items: items.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue == null) return;

        showDialog(
          context: context,
          builder: (_) => AppModal(
            title: "Update status to $newValue",
            message: "Are you sure?",
            onConfirm: () {
              Navigator.pop(context);
              setState(() => selectedValue = newValue); // ✅ keep UI synced
              _updateApplicationStatus(newValue);
            },
          ),
        );
      },
    );
  }
}


// RegisterDrowdownSelect(items: isOfw, initialValue: _isOfw, placeholder: 'Are you an OFW', onChanged: (value) { setState(() { _isOfw = value; }); }),