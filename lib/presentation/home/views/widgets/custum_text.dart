import 'package:flutter/material.dart';

class CustumText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight fontWeight;
  final int? maxLine;
  final Color? txtColor;
  final TextOverflow? overFlow;
  const CustumText({
    super.key,
    required this.text,
    required this.size,
    required this.fontWeight,
    this.maxLine,
    this.overFlow,  this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      style: TextStyle(
        fontSize: size,
        color: txtColor,
        fontWeight: fontWeight,
        overflow: overFlow,
      ),
    );
  }
}
