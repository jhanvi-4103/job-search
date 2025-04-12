import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final Function(String?) onSaved;
  final bool email;
  final bool password;
  final bool obscureText; // Add this line
  final String? initialValue;
  final TextInputType? keyboardType;
  // Add this line

  const CustomTextField({
    super.key,
    required this.label,
    required this.onSaved,
    this.email = false,
    this.initialValue,
    this.keyboardType,
    this.password = false,
    this.obscureText = false, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue, // Use this line
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
      onSaved: (value) => onSaved(value),
    );
  }
}
