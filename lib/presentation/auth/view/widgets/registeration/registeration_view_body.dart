import 'package:flutter/material.dart';
import 'package:menu_app/presentation/auth/view/widgets/registeration/register_form.dart';

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo[900]!, Colors.purple[800]!],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.3),
                    )
                  ],
                ),
              ),
            ),
          ),
          const RegistrationForm(),
        ],
      ),
    );
  }
}
