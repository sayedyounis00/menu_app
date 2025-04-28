import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/core/helper/validator.dart';
import 'package:menu_app/core/widget/failure_widget.dart';
import 'package:menu_app/core/widget/grident_button.dart';
import 'package:menu_app/core/widget/input_feild.dart';
import 'package:menu_app/presentation/admin_panel/view/admin_panel.dart';
import 'package:menu_app/presentation/auth/all/login_register_cubit.dart';
import 'package:menu_app/presentation/auth/all/login_register_state.dart';
import 'package:menu_app/presentation/auth/view/registeration_view.dart';
import 'package:menu_app/presentation/home/views/home_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obsecureText = true;
  bool isAdmin = true;
  void _toggleUserType(bool admin) {
    setState(() {
      isAdmin = admin;
    });
  }

  void _submitForm() {
    if (isAdmin) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        // Perform admin login logic
        BlocProvider.of<AuthntaCubit>(context).signIn(
            email: emailController.text, password: passwordController.text);
      }
    } else {
      // Perform client entry logic
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.25,
      left: 20,
      right: 20,
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAdmin ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _toggleUserType(true),
                    child: const Text('Admin'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isAdmin ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _toggleUserType(false),
                    child: const Text('Client'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (isAdmin)
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputField(
                          label: 'Email',
                          icon: Icons.email,
                          controller: emailController,
                          validator: ValidateFunction.validateEmail),
                      const SizedBox(height: 20),
                      InputField(
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: obsecureText,
                          suffixIcon: IconButton(
                              onPressed: () {
                                obsecureText = !obsecureText;
                                setState(() {});
                              },
                              icon: Icon(obsecureText
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye)),
                          controller: passwordController,
                          validator: ValidateFunction.validatePassword),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              BlocConsumer<AuthntaCubit, AuthnticationState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPanelView(),
                      ),
                    );
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: FailureWidget(errorMessage: state.message),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return GradientButton(
                    text: state is AuthLoading
                        ? " loading.."
                        : isAdmin
                            ? 'LOGIN '
                            : 'LOG IN AS CLIENT',
                    colors: const [Colors.purple, Colors.deepPurple],
                    onPressed: () {
                      if (state is AuthLoading) return;
                      _submitForm();
                    },
                  );
                },
              ),
              TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterView(),
                    )),
                child: const Text('Don\'t Have an Account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
