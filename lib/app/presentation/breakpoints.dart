import 'package:flutter/widgets.dart';

/// Breakpoint constants for responsive layout decisions.
abstract class Breakpoints {
  static const double breakpoint = 1000;
  static bool isMobile(double width) => width < breakpoint;
  static bool isDesktop(double width) => width >= breakpoint;
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
