import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/core/widget/failure_widget.dart';
import 'package:menu_app/core/widget/grident_button.dart';
import 'package:menu_app/core/widget/input_feild.dart';
import 'package:menu_app/presentation/admin_panel/view/admin_panel.dart';
import 'package:menu_app/presentation/auth/all/login_register_cubit.dart';
import 'package:menu_app/presentation/auth/all/login_register_state.dart';
import 'package:menu_app/presentation/auth/view/login_view.dart';

class ConfirmCodeForm extends StatefulWidget {
  final String email;
  const ConfirmCodeForm({super.key, required this.email});

  @override
  State<ConfirmCodeForm> createState() => _ConfirmCodeFormState();
}

class _ConfirmCodeFormState extends State<ConfirmCodeForm> {
  final _formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  bool _isResendDisabled = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    codeController.dispose();
    super.dispose();
  }

  String? validateCode(String? value) {
    if (value == null || value.isEmpty) return 'Code is required';
    if (value.length != 6) return 'Code must be 6 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Only numbers allowed';
    return null;
  }

  void _startResendTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_resendTimer == 0) {
          _timer?.cancel();
          _isResendDisabled = false;
        } else {
          _resendTimer--;
        }
      });
    });
  }

  void _handleResendCode() {
    context.read<AuthntaCubit>().resendConfirmationCode(widget.email);
    _startResendTimer();
    setState(() {
      _isResendDisabled = true;
      _resendTimer = 60;
    });
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    context
        .read<AuthntaCubit>()
        .verifyEmailWithCode(
            confirmationCode: codeController.text, email: widget.email)
        .then((value) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminPanelView(),
            ),
          );
        }
      });
    });
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
                Text(
                  'Check your email for the 6-digit code',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 25),
                InputField(
                  label: 'Verification Code',
                  icon: Icons.lock_reset,
                  controller: codeController,
                  validator: validateCode,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Text(
                  'Didn\'t receive the code?',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                TextButton(
                  onPressed: _isResendDisabled ? null : _handleResendCode,
                  child: Text(
                    _isResendDisabled ? "Resend $_resendTimer" : 'Resend Code',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 30),
                BlocConsumer<AuthntaCubit, AuthnticationState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
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
                      text: 'VERIFY',
                      colors: [Colors.pink[400]!, Colors.deepOrange[400]!],
                      onPressed: () {
                        _submitForm(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
