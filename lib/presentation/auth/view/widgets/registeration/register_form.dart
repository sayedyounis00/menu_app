// registration_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/core/helper/validator.dart';
import 'package:menu_app/core/widget/failure_widget.dart';
import 'package:menu_app/core/widget/grident_button.dart';
import 'package:menu_app/core/widget/input_feild.dart';
import 'package:menu_app/presentation/auth/all/login_register_cubit.dart';
import 'package:menu_app/presentation/auth/all/login_register_state.dart';
import 'package:menu_app/presentation/auth/view/confirm_view.dart';
import 'package:menu_app/presentation/auth/view/login_view.dart';

import 'password_strength_meter.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool obsecureText = true;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    confirmPasswordController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.25,
      left: 20,
      right: 20,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                InputField(
                  label: 'Email',
                  icon: Icons.email,
                  controller: emailController,
                  validator: ValidateFunction.validateEmail,
                ),
                const SizedBox(height: 15),
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
                          ? Icons.remove_red_eye_rounded
                          : Icons.remove_red_eye_outlined)),
                  controller: passwordController,
                  validator: ValidateFunction.validatePassword,
                  onChange: (val) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),
                PasswordStrengthMeter(password: passwordController.text),
                const SizedBox(height: 15),
                InputField(
                  label: 'Confirm Password',
                  icon: Icons.lock_reset,
                  obscureText: obsecureText,
                  controller: confirmPasswordController,
                  validator: validateConfirmPassword,
                ),
                const SizedBox(height: 25),
                BlocConsumer<AuthntaCubit, AuthnticationState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmView(
                            email: emailController.text,
                          ),
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
                      text: state is AuthLoading ? 'Loading' : 'REGISTER',
                      colors: [Colors.pink[400]!, Colors.deepOrange[400]!],
                      onPressed: () {
                        if (state is AuthLoading) return;
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthntaCubit>(context).signUp(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      )),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
