import 'package:flutter/material.dart';

class CustumText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  const CustumText({
    super.key,
    required this.text,
    required this.size,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: fontWeight),
    );
  }
}