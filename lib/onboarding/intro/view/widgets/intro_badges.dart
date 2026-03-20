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
    return ResponsiveScaffold(
      mobile: _buildBadges(
        context,
        textStyle: AppTextStyles.bodyLargeMobile,
        yearHorizontalPadding: 30,
        yearVerticalPadding: 10,
      ),
      desktop: _buildBadges(
        context,
        textStyle: AppTextStyles.bodyLargeMobile.copyWith(fontSize: 18),
        yearVerticalPadding: 7,
      ),
    );
  }

  Widget _buildBadges(
    BuildContext context, {
    required TextStyle textStyle,
    required double yearVerticalPadding,
    double yearHorizontalPadding = 26,
  }) {
    return Transform.scale(
      scale: 1.15,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: _yearOffset,
            child: Transform.rotate(
              angle: _yearAngle,
              child: _buildYearPill(
                context,
                textStyle: textStyle,
                verticalPadding: yearVerticalPadding,
                horizontalPadding: yearHorizontalPadding,
              ),
            ),
          ),
          Transform.translate(
            offset: _genUiOffset,
            child: Transform.rotate(
              angle: _genUiAngle,
              child: _buildGenUiPill(context, textStyle: textStyle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearPill(
    BuildContext context, {
    required TextStyle textStyle,
    required double verticalPadding,
    double horizontalPadding = 26,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppColors>()?.primary,
        borderRadius: const BorderRadius.all(Radius.circular(150)),
      ),
      child: Text(
        '2026',
        style: textStyle.copyWith(
          color: const Color(0xCC000000),
        ),
      ),
    );
  }

  Widget _buildGenUiPill(BuildContext context, {required TextStyle textStyle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(150)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: -0.3,
            child: Assets.images.intro.softstargradient.svg(
              width: 28,
              height: 28,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            context.l10n.genUILabel,
            style: textStyle.copyWith(
              color: const Color(0xCC000000),
            ),
          ),
        ],
      ),
    );
  }
}
