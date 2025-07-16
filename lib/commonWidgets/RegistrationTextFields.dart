import 'package:flutter/material.dart';

class RegistrationTextFields extends StatelessWidget {
  const RegistrationTextFields({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
    this.style = const TextStyle(),
    this.enabled = true
  });

  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextStyle? style;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        label: Text(
          label,
          style: style,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
      ),
    );
  }
}
