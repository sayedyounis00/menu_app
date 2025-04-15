import 'package:flutter/material.dart';
import 'package:menu_app/presentation/views/widgets/custum_text.dart';

class OrderCount extends StatelessWidget {
  final int count;
  const OrderCount({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey),
        child:
            CustumText(text: "$count", size: 20, fontWeight: FontWeight.bold));
  }
}