import 'package:flutter/material.dart';

/// Custom error widget for displaying error messages with retry functionality
class CustomErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final ErrorSeverity severity;
  final bool showIcon;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.severity = ErrorSeverity.error,
    this.showIcon = true,
  });

  /// Creates a network error widget
  const CustomErrorWidget.network({
    super.key,
    this.message = 'Unable to connect to the server. Please check your internet connection.',
    this.title = 'Connection Error',
    this.icon = Icons.wifi_off,
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.severity = ErrorSeverity.error,
    this.showIcon = true,
  });

  /// Creates a not found error widget
  const CustomErrorWidget.notFound({
    super.key,
    this.message = 'The requested resource was not found.',
    this.title = 'Not Found',
    this.icon = Icons.search_off,
    this.onRetry,
    this.retryButtonText = 'Go Back',
    this.severity = ErrorSeverity.warning,
    this.showIcon = true,
  });

  /// Creates an unauthorized error widget
  const CustomErrorWidget.unauthorized({
    super.key,
    this.message = 'You don\'t have permission to access this resource.',
    this.title = 'Access Denied',
    this.icon = Icons.lock,
    this.onRetry,
    this.retryButtonText = 'Login',
    this.severity = ErrorSeverity.error,
    this.showIcon = true,
  });

  /// Creates a generic error widget
  const CustomErrorWidget.generic({
    super.key,
    this.message = 'Something went wrong. Please try again.',
    this.title = 'Error',
    this.icon = Icons.error_outline,
    this.onRetry,
    this.retryButtonText = 'Retry',
    this.severity = ErrorSeverity.error,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color iconColor = switch (severity) {
      ErrorSeverity.error => theme.colorScheme.error,
      ErrorSeverity.warning => Colors.orange,
      ErrorSeverity.info => theme.colorScheme.primary,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                icon ?? Icons.error_outline,
                size: 64.0,
                color: iconColor,
              ),
              const SizedBox(height: 24.0),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Small inline error message widget
class InlineErrorMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onDismiss;

  const InlineErrorMessage({
    super.key,
    required this.message,
    this.icon = Icons.error,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20.0,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 12.0),
          ],
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20.0,
              color: theme.colorScheme.error,
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error severity levels
enum ErrorSeverity {
  error,
  warning,
  info,
}
