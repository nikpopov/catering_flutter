import 'package:flutter/material.dart';

/// Extension methods on BuildContext for easier access to common properties
extension BuildContextExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Get device pixel ratio
  double get devicePixelRatio => mediaQuery.devicePixelRatio;

  /// Get status bar height
  double get statusBarHeight => mediaQuery.padding.top;

  /// Get bottom padding (for notch/home indicator)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Get keyboard height
  double get keyboardHeight => mediaQuery.viewInsets.bottom;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Get orientation
  Orientation get orientation => mediaQuery.orientation;

  /// Check if portrait
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if landscape
  bool get isLandscape => orientation == Orientation.landscape;

  /// Check if device is mobile (small screen)
  bool get isMobile => screenWidth < 600;

  /// Check if device is tablet
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;

  /// Check if device is desktop (large screen)
  bool get isDesktop => screenWidth >= 900;

  /// Get primary color
  Color get primaryColor => colorScheme.primary;

  /// Get secondary color
  Color get secondaryColor => colorScheme.secondary;

  /// Get error color
  Color get errorColor => colorScheme.error;

  /// Get surface color
  Color get surfaceColor => colorScheme.surface;

  /// Get background color
  Color get backgroundColor => colorScheme.background;

  /// Check if dark mode is enabled
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if light mode is enabled
  bool get isLightMode => theme.brightness == Brightness.light;

  /// Show a snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: errorColor,
    );
  }

  /// Show warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
    );
  }

  /// Show info snackbar
  void showInfoSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: primaryColor,
    );
  }

  /// Show a dialog
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  /// Show a confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDestructive
                ? ElevatedButton.styleFrom(
                    backgroundColor: errorColor,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show a bottom sheet
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => child,
    );
  }

  /// Show loading dialog
  void showLoadingDialog({String? message}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Hide loading dialog
  void hideLoadingDialog() {
    Navigator.of(this, rootNavigator: true).pop();
  }

  /// Navigate to a route
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Replace current route
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Push and remove until
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (context) => page),
      (route) => false,
    );
  }

  /// Pop current route
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Check if can pop
  bool canPop() {
    return Navigator.of(this).canPop();
  }

  /// Focus/unfocus
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Request focus
  void requestFocus(FocusNode focusNode) {
    FocusScope.of(this).requestFocus(focusNode);
  }
}
