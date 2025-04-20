import 'package:flutter/material.dart';

class FailureScreen extends StatelessWidget {
  final Function() onPressed;
  const FailureScreen({
    super.key, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Please Check your internet connection"),
          TextButton(
              onPressed: onPressed,
              child: const Text("try again"))
        ],
      ),
    );
  }
}
