import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';
import 'package:vgv_genui_financial_advisor/gen/assets.gen.dart';
import 'package:vgv_genui_financial_advisor/l10n/l10n.dart';

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
            child: _buildYearPill(context),
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

  Widget _buildYearPill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()?.primary,
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
      child: Text(
        '2026',
        style: AppTextStyles.bodyLargeMobile.copyWith(
          fontSize: 18,
          color: const Color(0xCC000000),
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
          Assets.images.intro.softstargradient.svg(
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 6),
          Text(
            context.l10n.genUILabel,
            style: AppTextStyles.bodyLargeMobile.copyWith(
              fontSize: 18,
              color: const Color(0xCC000000),
            ),
          ),
        ],
      ),
    );
  }
}
