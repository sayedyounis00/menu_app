import 'package:flutter/material.dart';
import 'package:menu_app/presentation/auth/view/widgets/login/login_form.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.indigo[900]!, Colors.purple[800]!],
          radius: 1.1,
        ),
      ),
      child: Stack(
        children: [
          // WELCOME TEXT!
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
              ),
            ),
          ),
          const LoginForm(),
         
        ],
      ),
    );
  }
}
