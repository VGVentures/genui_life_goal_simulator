import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';

class GradientChip extends StatelessWidget {
  const GradientChip({
    required this.gradient,
    required this.asset,
    required this.onTap,
    this.label,
    super.key,
  });

  final LinearGradient gradient;
  final SvgGenImage asset;
  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label ?? '',
      leadingIcon: asset.svg(
        height: _Dimensions.iconHeight,
        width: Spacing.md,
      ),
      onPressed: onTap,
      variant: AppButtonVariant.gradient,
    );
  }
}

abstract final class _Dimensions {
  static const double iconHeight = 19;
}
