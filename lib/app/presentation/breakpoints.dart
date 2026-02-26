import 'package:flutter/widgets.dart';

/// Breakpoint constants for responsive layout decisions.
abstract class Breakpoints {
  static const double mobile = 600;
  static const double desktop = 600;
  static bool isMobile(double width) => width < mobile;
  static bool isDesktop(double width) => width >= desktop;
}

/// Returns [mobile] or [desktop] based on the current screen width.
T responsiveValue<T>(
  BuildContext context, {
  required T mobile,
  required T desktop,
}) {
  final width = MediaQuery.sizeOf(context).width;
  return Breakpoints.isMobile(width) ? mobile : desktop;
}
