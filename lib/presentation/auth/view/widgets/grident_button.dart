import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.text,
    required this.colors,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
