// auth_cubit.dart
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_app/core/network/failure.dart';
import 'package:menu_app/presentation/auth/all/login_register_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthntaCubit extends Cubit<AuthnticationState> {
  final SupabaseClient supabase;

  AuthntaCubit({required this.supabase}) : super(const AuthInitial());

  Future<void> signUp({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await supabase.auth.signUp(
        email: email.trim(),
        password: password.trim(),
      );
      log("Successfully signed up");
      emit(AuthAuthenticated());
    } catch (e) {
      final String errorMessage = SupabaseAuthErrorHandler.handleError(e);
      log(errorMessage);
      emit(AuthFailure(errorMessage));
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      emit(AuthAuthenticated());
    } catch (e) {
      final String errorMessage = SupabaseAuthErrorHandler.handleError(e);
      emit(AuthFailure(errorMessage));
    }
  }

  Future<void> verifyEmailWithCode({
    required String email,
    required String confirmationCode,
  }) async {
    emit(const AuthLoading());
    try {
      final supabaseClient = supabase;
      await supabaseClient.auth.verifyOTP(
        email: email,
        token: confirmationCode,
        type: OtpType.email,
      );

      // final user = response.user;
      // if (user?.emailConfirmedAt != null) {
      //   emit(const EmailVerified());
      // } else {
      //   emit(const AuthFailure('Email confirmation failed'));
      // }
    } catch (e) {
      final String errorMessage = SupabaseAuthErrorHandler.handleError(e);
      emit(AuthFailure(errorMessage));
    }
  }

  Future<void> resendConfirmationCode(String email) async {
    emit(const AuthLoading());
    try {
      final supabaseClient = supabase;
      await supabaseClient.auth.resend(
        type: OtpType.signup,
        email: email,
        emailRedirectTo: null,
      );
      emit(const ConfirmationCodeSent());
    } catch (e) {
      final String errorMessage = SupabaseAuthErrorHandler.handleError(e);
      emit(AuthFailure(errorMessage));
    }
  }

  void checkAuthStatus() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  // This method is no longer needed as we're using the SupabaseAuthErrorHandler
  // String _mapSupabaseError(var e) {
  //   // Old error mapping code removed
  // }
}
