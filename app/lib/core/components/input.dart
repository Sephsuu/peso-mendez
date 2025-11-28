import 'package:app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/services.dart';

class AppInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool? isEnabled;
  final int? maxLine;

  final double textSize;
  final double visualDensityY;

  // ⭐ NEW: Accept only numbers?
  final bool numericOnly;

  const AppInputField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.isEnabled = true,
    this.maxLine,
    this.textSize = 14,
    this.visualDensityY = -4,

    // ⭐ default: off
    this.numericOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLine ?? 1,
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      obscureText: obscureText,

      // ⭐ Use number keyboard when numericOnly = true
      keyboardType: numericOnly ? TextInputType.number : keyboardType,

      // ⭐ Add validator if needed
      validator: validator,
      onChanged: onChanged,
      enabled: isEnabled,

      style: TextStyle(fontSize: textSize),

      // ⭐ Only allow digits
      inputFormatters: numericOnly
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,

      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.light,
        isDense: true,
        visualDensity: VisualDensity(vertical: visualDensityY),

        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontSize: textSize),
        hintStyle: TextStyle(fontSize: textSize * 0.9),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

class RegisterTextFieldPlaceholderRequired extends StatefulWidget {
  final TextEditingController controller;
  final String? placeholder;

  const RegisterTextFieldPlaceholderRequired({
    super.key,
    required this.controller,
    this.placeholder, // If you want placeholder optional, remove required
  });

  @override
  _RegisterTextFieldPlaceholderRequiredState createState() => _RegisterTextFieldPlaceholderRequiredState();
}
class _RegisterTextFieldPlaceholderRequiredState extends State<RegisterTextFieldPlaceholderRequired> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
        ),
        labelText: widget.placeholder,
        labelStyle: AppText.textMuted,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        isDense: true
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

class RegisterTextFieldPlaceholder extends StatefulWidget {
  final TextEditingController controller;
  final String? placeholder;
  final bool enabled;

  // NEW ARGUMENTS
  final bool obscureText;
  final String obscuringCharacter;
  final List<TextInputFormatter>? inputFormatters;

  const RegisterTextFieldPlaceholder({
    super.key,
    required this.controller,
    this.placeholder,
    this.enabled = true,

    // Defaults
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.inputFormatters,
  });

  @override
  _RegisterTextFieldPlaceholderState createState() =>
      _RegisterTextFieldPlaceholderState();
}

class _RegisterTextFieldPlaceholderState
    extends State<RegisterTextFieldPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193)),
        ),
        labelText: widget.placeholder,
        labelStyle: AppText.textMuted,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        isDense: true,
      ),
    );
  }
}


class RegisterTextareaFieldPlaceholderRequired extends StatefulWidget {
  final TextEditingController controller;
  final String? placeholder;

  const RegisterTextareaFieldPlaceholderRequired({
    super.key,
    required this.controller,
    this.placeholder, // If you want placeholder optional, remove required
  });

  @override
  _RegisterTextareaFieldPlaceholderRequiredState createState() => _RegisterTextareaFieldPlaceholderRequiredState();
}
class _RegisterTextareaFieldPlaceholderRequiredState extends State<RegisterTextareaFieldPlaceholderRequired> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 3,
      controller: widget.controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
        ),
        labelText: widget.placeholder,
        labelStyle: AppText.textMuted,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        isDense: true
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final int? maxLine;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLine
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}
class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, textAlign: TextAlign.start, style: AppText.textSm),
        const SizedBox(height: 7.0),
        TextFormField(
          maxLines: widget.maxLine,
          controller: widget.controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 193, 193, 193))
            ),
            labelText: null,
            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            isDense: true
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}