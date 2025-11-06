import 'package:flutter/material.dart';

/// Custom button widget with consistent styling across the app
/// Supports primary, secondary, and text button variants
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine button dimensions based on size
    final double height = switch (size) {
      ButtonSize.small => 36.0,
      ButtonSize.medium => 48.0,
      ButtonSize.large => 56.0,
    };

    final double fontSize = switch (size) {
      ButtonSize.small => 14.0,
      ButtonSize.medium => 16.0,
      ButtonSize.large => 18.0,
    };

    final double iconSize = switch (size) {
      ButtonSize.small => 18.0,
      ButtonSize.medium => 20.0,
      ButtonSize.large => 24.0,
    };

    // Build button content
    Widget buttonChild = isLoading
        ? SizedBox(
            height: iconSize,
            width: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTextColor(theme),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSize, color: _getTextColor(theme)),
                const SizedBox(width: 8.0),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: _getTextColor(theme),
                ),
              ),
            ],
          );

    // Build button based on variant
    Widget button = switch (variant) {
      ButtonVariant.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.primaryColor,
            foregroundColor: textColor ?? Colors.white,
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: size == ButtonSize.small ? 16.0 : 24.0,
              vertical: size == ButtonSize.small ? 8.0 : 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            ),
            elevation: 2.0,
            minimumSize: Size(0, height),
          ),
          child: buttonChild,
        ),
      ButtonVariant.secondary => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: backgroundColor ?? theme.primaryColor,
            side: BorderSide(
              color: backgroundColor ?? theme.primaryColor,
              width: 1.5,
            ),
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: size == ButtonSize.small ? 16.0 : 24.0,
              vertical: size == ButtonSize.small ? 8.0 : 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            ),
            minimumSize: Size(0, height),
          ),
          child: buttonChild,
        ),
      ButtonVariant.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: backgroundColor ?? theme.primaryColor,
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: size == ButtonSize.small ? 12.0 : 16.0,
              vertical: size == ButtonSize.small ? 8.0 : 12.0,
            ),
            minimumSize: Size(0, height),
          ),
          child: buttonChild,
        ),
      ButtonVariant.danger => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.red,
            foregroundColor: textColor ?? Colors.white,
            padding: padding ?? EdgeInsets.symmetric(
              horizontal: size == ButtonSize.small ? 16.0 : 24.0,
              vertical: size == ButtonSize.small ? 8.0 : 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
            ),
            elevation: 2.0,
            minimumSize: Size(0, height),
          ),
          child: buttonChild,
        ),
    };

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Color _getTextColor(ThemeData theme) {
    if (textColor != null) return textColor!;

    return switch (variant) {
      ButtonVariant.primary => Colors.white,
      ButtonVariant.secondary => backgroundColor ?? theme.primaryColor,
      ButtonVariant.text => backgroundColor ?? theme.primaryColor,
      ButtonVariant.danger => Colors.white,
    };
  }
}

/// Button style variants
enum ButtonVariant {
  primary,
  secondary,
  text,
  danger,
}

/// Button size variants
enum ButtonSize {
  small,
  medium,
  large,
}
