import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

class TrustBadge extends StatelessWidget {
  const TrustBadge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
    this.icon,
    super.key,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final TextStyle textStyle;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: icon != null ? Spacing.xs : Spacing.lg,
        right: Spacing.lg,
        top: Spacing.xs,
        bottom: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Spacing.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: Spacing.xs),
          ],
          Text(
            text,
            style: textStyle.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
