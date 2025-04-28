// signin_failure_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/core/widget/grident_button.dart';
import 'package:menu_app/presentation/home/menu/menu_cubit.dart';

class FailureWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? retryCallback;

  const FailureWidget({
    super.key,
    required this.errorMessage,
    this.retryCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.red[900]!, Colors.orange[800]!],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            GradientButton(
              text: retryCallback != null ? 'TRY AGAIN' : 'CLOSE',
              colors: [Colors.pink[700]!, Colors.deepOrange[700]!],
              onPressed: retryCallback ??
                  () {
                    BlocProvider.of<MenuCubit>(context).getAllMenuItems();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
            ),
          ],
        ),
      ),
    );
  }
}
