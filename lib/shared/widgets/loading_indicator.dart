import 'package:flutter/material.dart';

/// Loading indicator widget with multiple variants
class LoadingIndicator extends StatelessWidget {
  final LoadingSize size;
  final Color? color;
  final String? message;
  final LoadingVariant variant;

  const LoadingIndicator({
    super.key,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.variant = LoadingVariant.circular,
  });

  /// Creates a full-screen loading overlay
  const LoadingIndicator.fullScreen({
    super.key,
    this.size = LoadingSize.large,
    this.color,
    this.message,
    this.variant = LoadingVariant.circular,
  });

  /// Creates a small inline loading indicator
  const LoadingIndicator.inline({
    super.key,
    this.size = LoadingSize.small,
    this.color,
    this.message,
    this.variant = LoadingVariant.circular,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.primaryColor;

    final double indicatorSize = switch (size) {
      LoadingSize.small => 16.0,
      LoadingSize.medium => 24.0,
      LoadingSize.large => 40.0,
    };

    Widget indicator = switch (variant) {
      LoadingVariant.circular => SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: size == LoadingSize.small ? 2.0 : 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
      LoadingVariant.linear => SizedBox(
          width: 200.0,
          child: LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        ),
      LoadingVariant.dots => _DotsLoadingIndicator(
          color: indicatorColor,
          size: indicatorSize,
        ),
    };

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          indicator,
          const SizedBox(height: 16.0),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return indicator;
  }
}

/// Custom dots loading animation
class _DotsLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const _DotsLoadingIndicator({
    required this.color,
    required this.size,
  });

  @override
  State<_DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<_DotsLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final scale = (value < 0.5
                ? value * 2
                : (1 - value) * 2);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Transform.scale(
                scale: 0.5 + (scale * 0.5),
                child: Container(
                  width: widget.size / 2,
                  height: widget.size / 2,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Full-screen loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withOpacity(0.5),
            child: Center(
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: LoadingIndicator(
                    size: LoadingSize.large,
                    color: indicatorColor,
                    message: message,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum LoadingSize {
  small,
  medium,
  large,
}

enum LoadingVariant {
  circular,
  linear,
  dots,
}
