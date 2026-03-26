import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template get_started_button}
/// A gradient pill button used on the intro screen.
///
/// {@endtemplate}
class GetStartedButton extends StatelessWidget {
  /// {@macro get_started_button}
  const GetStartedButton({
    required this.onPressed,
    this.label = 'Get Started',
    this.height = 65,
    super.key,
  });

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Button label text. Defaults to `'Get Started'`.
  final String label;

  /// Button height. Defaults to `48`.
  final double height;

  static const _gradient = LinearGradient(
    colors: [Color.fromRGBO(36, 97, 235, 1), Color(0xFFD4C6FB)],
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: _gradient,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          onTap: onPressed,
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.black.withValues(alpha: 0.2);
            }
            if (states.contains(WidgetState.pressed)) {
              return Colors.black.withValues(alpha: 0.3);
            }
            return null;
          }),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Center(
                child: ResponsiveScaffold(
                  mobile: Text(
                    label,
                    style: AppTextStyles.labelLargeMobile.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  desktop: Text(
                    label,
                    style: AppTextStyles.labelLargeDesktop.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
