import 'package:flutter/material.dart';

class AppInp extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const AppInp(
    this.label, {
    required this.controller,
    this.errorText,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleVisibility,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: const OutlineInputBorder(),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}
