import 'package:flutter/widgets.dart';
import 'package:vgv_genui_financial_advisor/design_system/breakpoints.dart';

/// A scaffold that conditionally renders mobile or desktop layouts
/// based on screen width.
///
/// Uses [MediaQuery] to respond to total screen width, ensuring
/// consistent behavior across all widgets regardless of parent
/// constraints.
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.mobile,
    required this.desktop,
    super.key,
  });

  final Widget mobile;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return responsiveValue(context, mobile: mobile, desktop: desktop);
  }
}
