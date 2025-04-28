// registration_page.dart
import 'package:flutter/material.dart';
import 'package:menu_app/presentation/auth/view/widgets/registeration/registeration_view_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RegisterViewBody(),
    );
  }
}
