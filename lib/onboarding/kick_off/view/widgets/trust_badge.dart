import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

class TrustBadge extends StatelessWidget {
  const TrustBadge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    super.key,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.xs,
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
            const SizedBox(width: Spacing.xxs),
          ],
          Text(
            text,
            style: AppTextStyles.bodySmall?.copyWith(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
