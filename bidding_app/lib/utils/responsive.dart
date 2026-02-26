import 'package:flutter/material.dart';

/// Screen size breakpoints (matching Tailwind's defaults)
class Breakpoints {
  static const double sm = 640;   // Small phones
  static const double md = 768;   // Tablets / large phones landscape
  static const double lg = 1024;  // Small desktops / tablets landscape
  static const double xl = 1280;  // Desktop
}

/// Responsive helper – use this anywhere in your widget tree
class Responsive {
  final BuildContext context;
  final double width;

  Responsive(this.context) : width = MediaQuery.of(context).size.width;

  bool get isMobile  => width < Breakpoints.md;
  bool get isTablet  => width >= Breakpoints.md && width < Breakpoints.lg;
  bool get isDesktop => width >= Breakpoints.lg;

  /// Pick a value based on screen size. Falls back to smaller size if not provided.
  T value<T>({required T mobile, T? tablet, required T desktop}) {
    if (isDesktop) return desktop;
    if (isTablet)  return tablet ?? mobile;
    return mobile;
  }
}

/// Convenience extension so you can write context.responsive.isMobile
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
  double get screenWidth  => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile  => screenWidth < Breakpoints.md;
  bool get isTablet  => screenWidth >= Breakpoints.md && screenWidth < Breakpoints.lg;
  bool get isDesktop => screenWidth >= Breakpoints.lg;
}

/// A widget that rebuilds whenever screen size crosses a breakpoint
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Responsive responsive) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => builder(context, Responsive(context)),
    );
  }
}

/// Layout that shows different widgets per screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) return desktop;
    if (context.isTablet)  return tablet ?? mobile;
    return mobile;
  }
}
