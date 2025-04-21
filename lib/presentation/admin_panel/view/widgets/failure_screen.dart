import 'package:flutter/material.dart';

class FailureScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final String errorMessage;
  final Widget? icon;
  final String? retryButtonText;
  final Color? textColor;
  final Color? buttonColor;
  final EdgeInsetsGeometry? padding;

  const FailureScreen({
    super.key,
    required this.onRetry,
    required this.errorMessage,
    this.icon,
    this.retryButtonText,
    this.textColor,
    this.buttonColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNetworkError = errorMessage.toLowerCase().contains('network');

    return Padding(
      padding: padding ?? const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ??
              Icon(
                isNetworkError ? Icons.wifi_off : Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
          const SizedBox(height: 24),
          Text(
            isNetworkError ? 'Connection Error' : 'Something Went Wrong',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: textColor ?? theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isNetworkError
                ? 'Please check your internet connection and try again'
                : errorMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor ?? theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: buttonColor ?? theme.colorScheme.errorContainer,
              foregroundColor: buttonColor != null
                  ? theme.colorScheme.onErrorContainer
                  : null,
            ),
            child: Text(retryButtonText ?? 'Try Again'),
          ),
        ],
      ),
    );
  }
}
