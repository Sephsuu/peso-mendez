import 'package:flutter/material.dart';
import 'package:app/core/theme/typography.dart';

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

  const RegisterTextFieldPlaceholder({
    super.key,
    required this.controller,
    this.placeholder, // If you want placeholder optional, remove required
  });

  @override
  _RegisterTextFieldPlaceholderState createState() => _RegisterTextFieldPlaceholderState();
}

class _RegisterTextFieldPlaceholderState extends State<RegisterTextFieldPlaceholder> {
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
    );
  }
}