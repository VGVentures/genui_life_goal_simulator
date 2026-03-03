import 'dart:math' show pi;

import 'package:finance_app/gen/assets.gen.dart';
import 'package:finance_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// {@template intro_badges}
/// The "2026 ✦ Gen UI" overlapping badges shown on the intro screen.
/// {@endtemplate}
class IntroBadges extends StatelessWidget {
  /// {@macro intro_badges}
  const IntroBadges({super.key});

  static const double _yearAngle = -15 * pi / 180;
  static const double _genUiAngle = 12.91 * pi / 180;

  static const _yearOffset = Offset(-50, 0);
  static const _genUiOffset = Offset(35, 0);

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
            child: _buildGenUiPill(context),
          ),
        ),
      ],
    );
  }

  Widget _buildYearPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
      decoration: const BoxDecoration(
        color: Color(0xFF9DB6F8),
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
      child: const Text(
        '2026',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xCC000000),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGenUiPill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.images.intro.softstargradient,
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 6),
          Text(
            context.l10n.genUILabel,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xCC000000),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
