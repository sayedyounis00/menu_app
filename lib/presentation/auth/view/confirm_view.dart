import 'package:flutter/material.dart';
import 'package:menu_app/presentation/auth/view/widgets/confirmView/confirm_view_body.dart';

class ConfirmView extends StatelessWidget {
  final String email;
  const ConfirmView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmViewBody(
        email: email,
      ),
    );
  }
}
