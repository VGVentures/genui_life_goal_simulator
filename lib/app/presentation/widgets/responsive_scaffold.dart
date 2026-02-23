import 'package:finance_app/app/presentation/breakpoints.dart';
import 'package:flutter/widgets.dart';

/// A scaffold that conditionally renders mobile or desktop layouts
/// based on parent constraints.
///
/// Uses [LayoutBuilder] to respond to parent constraints rather than
/// screen size, enabling proper behavior when embedded in other widgets
/// or during window resizing.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isMobile(constraints.maxWidth)) {
          return mobile;
        }
        return desktop;
      },
    );
  }
}
