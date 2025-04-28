import 'package:flutter/material.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({super.key, required this.password});

  int _calculateStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    return strength;
  }

  @override
  Widget build(BuildContext context) {
    int strength = _calculateStrength(password);
    String strengthText;
    Color strengthColor;

    switch (strength) {
      case 0:
        strengthText = 'Very Weak';
        strengthColor = Colors.red;
        break;
      case 1:
        strengthText = 'Weak';
        strengthColor = Colors.orange;
        break;
      case 2:
        strengthText = 'Moderate';
        strengthColor = Colors.yellow;
        break;
      case 3:
        strengthText = 'Strong';
        strengthColor = Colors.green;
        break;
      case 4:
        strengthText = 'Very Strong';
        strengthColor = Colors.blue;
        break;
      default:
        strengthText = 'Very Weak';
        strengthColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(4),
          value: strength / 3.0,
          minHeight: 8,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
        ),
        const SizedBox(height: 8),
        Text(
          strengthText,
          style: TextStyle(
            color: strengthColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
