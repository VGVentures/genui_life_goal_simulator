import 'package:flutter/material.dart';

/// {@template get_started_button}
/// A gradient pill button used on the intro screen.
///
/// Wrap with a [SizedBox] to control the width.
/// {@endtemplate}
class GetStartedButton extends StatelessWidget {
  /// {@macro get_started_button}
  const GetStartedButton({
    required this.onPressed,
    this.label = 'Get started',
    this.height = 80,
    this.fontSize = 24,
    this.fontWeight = FontWeight.w600,
    super.key,
  });

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Button label text. Defaults to `'Get started'`.
  final String label;

  /// Button height. Defaults to `80`.
  final double height;

  /// Font size. Defaults to `24`.
  final double fontSize;

  /// Font weight. Defaults to [FontWeight.w600].
  final FontWeight fontWeight;

  static const _gradient = LinearGradient(
    colors: [Color(0xFF2461EB), Color(0xFFD4C6FB)],
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
          child: SizedBox(
            height: height,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
