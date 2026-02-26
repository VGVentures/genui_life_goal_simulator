import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// {@template intro_badge}
/// The "2026 ✦ Gen UI" overlapping pill badges shown on the intro screen.
/// {@endtemplate}
class IntroBadge extends StatelessWidget {
  /// {@macro intro_badge}
  const IntroBadge({super.key});

  static const double _yearAngle = -15 * pi / 180;
  static const double _genUiAngle = 12.91 * pi / 180;

  static const _yearOffset = Offset(-45, 0);
  static const _genUiOffset = Offset(28, 0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: _yearOffset,
          child: Transform.rotate(
            angle: _yearAngle,
            child: _buildYearPill(),
          ),
        ),
        Transform.translate(
          offset: _genUiOffset,
          child: Transform.rotate(
            angle: _genUiAngle,
            child: _buildGenUiPill(),
          ),
        ),
      ],
    );
  }

  Widget _buildYearPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF9DB6F8),
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
      child: const Text(
        '2026',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xCC000000),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildGenUiPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/intro/softstargradient.svg',
            width: 18,
            height: 18,
          ),
          const SizedBox(width: 6),
          const Text(
            'Gen UI',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xCC000000),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
