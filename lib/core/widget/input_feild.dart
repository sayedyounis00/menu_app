import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const InputField({
    super.key,
    required this.label,
    required this.icon,
    this.obscureText = false,
    required this.controller,
    required this.validator,
    this.onChange,
    this.suffixIcon,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      onChanged: onChange,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}
