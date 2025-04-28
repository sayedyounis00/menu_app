import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A utility class for handling Supabase authentication errors.
/// This class provides methods to parse, format, and handle various
/// authentication-related exceptions thrown by Supabase.
class SupabaseAuthErrorHandler {
  /// Handles all types of authentication errors and returns user-friendly messages
  static String handleError(dynamic error) {
    // Handle Supabase specific errors
    if (error is AuthException) {
      return _handleAuthException(error);
    }
    // Handle PostgreSQL errors
    else if (error is PostgrestException) {
      return _handlePostgrestException(error);
    }
    // Handle general Supabase errors
    else if (error is AuthApiException) {
      return _handleSupabaseException(error);
    }
    // Handle network errors
    else if (error is SocketException) {
      return 'Network error: Please check your internet connection';
    }
    // Handle timeout errors
    else if (error is TimeoutException) {
      return 'Request timed out: Please try again later';
    }
    // Fallback for any other types of errors
    else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }

  /// Handle authentication-specific exceptions
  static String _handleAuthException(AuthException error) {
    final String errorMessage = error.message.toLowerCase();

    // Email-related errors
    if (errorMessage.contains('email') && errorMessage.contains('not found')) {
      return 'No account found with this email. Please register first.';
    } else if (errorMessage.contains('email') &&
        errorMessage.contains('already')) {
      return 'An account with this email already exists.';
    }
    // Password errors
    else if (errorMessage.contains('password') &&
        errorMessage.contains('weak')) {
      return 'Password is too weak. Please choose a stronger password.';
    } else if (errorMessage.contains('password') &&
        errorMessage.contains('incorrect')) {
      return 'Incorrect password. Please try again.';
    }
    // Token errors
    else if (errorMessage.contains('token') &&
        errorMessage.contains('expired')) {
      return 'Your session has expired. Please log in again.';
    } else if (errorMessage.contains('token') &&
        errorMessage.contains('invalid')) {
      return 'Invalid authentication token. Please log in again.';
    }
    // Rate limiting
    else if (errorMessage.contains('too many requests') ||
        errorMessage.contains('rate limit')) {
      return 'Too many attempts. Please try again later.';
    }
    // User disabled or banned
    else if (errorMessage.contains('disabled') ||
        errorMessage.contains('banned')) {
      return 'This account has been disabled. Please contact support.';
    }
    // MFA related
    else if (errorMessage.contains('mfa') ||
        errorMessage.contains('multi-factor')) {
      return 'Multi-factor authentication required. Please complete the verification process.';
    }
    // Fallback for other auth errors
    else {
      return 'Authentication error: ${error.message}';
    }
  }

  /// Handle PostgreSQL database errors
  static String _handlePostgrestException(PostgrestException error) {
    final String errorMessage = error.message.toLowerCase();
    final String details = error.details.toString();

    if (errorMessage.contains('foreign key constraint')) {
      return 'Database relation error. This action references data that does not exist.';
    }
    // Unique constraint errors
    else if (errorMessage.contains('unique constraint')) {
      return 'This information already exists in our system.';
    }
    // Permission errors
    else if (errorMessage.contains('permission denied')) {
      return 'You do not have permission to perform this action.';
    }
    // Row level security
    else if (errorMessage.contains('rls')) {
      return 'Access denied due to security policies.';
    }
    // Fallback for other database errors
    else {
      return 'Database error: $details';
    }
  }

  /// Handle general Supabase errors
  static String _handleSupabaseException(AuthApiException error) {
    final String errorMessage = error.message.toLowerCase();

    // Storage errors
    if (errorMessage.contains('storage')) {
      return 'Storage error: ${error.message}';
    }
    // Function errors
    else if (errorMessage.contains('function')) {
      return 'Server function error: ${error.message}';
    }
    // Realtime errors
    else if (errorMessage.contains('realtime') ||
        errorMessage.contains('subscription')) {
      return 'Realtime connection error: ${error.message}';
    }
    // Fallback for other Supabase errors
    else {
      return 'Supabase error: ${error.message}';
    }
  }

  /// Show a snackbar with the error message
  static void showErrorSnackBar(BuildContext context, dynamic error) {
    final String errorMessage = handleError(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show an error dialog with the error message
  static Future<void> showErrorDialog(
      BuildContext context, dynamic error) async {
    final String errorMessage = handleError(error);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: Text(errorMessage),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/// Example usage:
/// ```dart
/// try {
///   await supabase.auth.signInWithPassword(
///     email: 'example@email.com',
///     password: 'password',
///   );
/// } catch (error) {
///   // Option 1: Get error message as string
///   String errorMessage = SupabaseAuthErrorHandler.handleError(error);
///   print(errorMessage);
///
///   // Option 2: Show error in a snackbar
///   SupabaseAuthErrorHandler.showErrorSnackBar(context, error);
///
///   // Option 3: Show error in a dialog
///   await SupabaseAuthErrorHandler.showErrorDialog(context, error);
/// }
/// ```
