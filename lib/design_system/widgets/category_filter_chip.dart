import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/app_colors.dart';
import 'package:genui_life_goal_simulator/design_system/app_text_styles.dart';
import 'package:genui_life_goal_simulator/design_system/filter_chip_color.dart';
import 'package:genui_life_goal_simulator/design_system/spacing.dart';

export 'package:genui_life_goal_simulator/design_system/filter_chip_color.dart';

class CategoryFilterChip extends StatefulWidget {
  const CategoryFilterChip({
    required this.color,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.isEnabled = true,
    this.borderRadius = 32,
    this.hoveredOpacity = 0.15,
    super.key,
  });

  final FilterChipColor color;
  final String label;

  final bool? isSelected;

  final VoidCallback? onTap;
  final bool isEnabled;

  /// Corner radius of the pill-shaped chip.
  final double borderRadius;

  /// Background alpha applied to the base color while hovered.
  final double hoveredOpacity;

  @override
  State<CategoryFilterChip> createState() => _CategoryFilterChipState();
}

class _CategoryFilterChipState extends State<CategoryFilterChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final baseColor = widget.color.toColor(colors);
    final isDisabled = !widget.isEnabled;

    final Color backgroundColor;
    final Color textColor;
    final BoxBorder? border;

    if (isDisabled) {
      if (widget.isSelected ?? false) {
        backgroundColor = colors.surfaceContainerHigh;
        border = null;
      } else {
        backgroundColor = colors.surfaceContainer;
        border = Border.all(
          color: colors.outlineVariant,
        );
      }
      textColor = colors.onSurfaceDisabled;
    } else if (widget.isSelected ?? false) {
      backgroundColor = baseColor;
      border = null;
      textColor = widget.color.useDarkTextWhenSelected
          ? colors.onSurfaceVariant
          : colors.onPrimary;
    } else {
      if (_isHovered) {
        backgroundColor = baseColor.withValues(
          alpha: widget.hoveredOpacity,
        );
      } else {
        backgroundColor = colors.surfaceVariant;
      }
      border = Border.all(color: baseColor);
      textColor = colors.onSurfaceVariant;
    }

    return MouseRegion(
      onEnter: isDisabled ? null : (_) => setState(() => _isHovered = true),
      onExit: isDisabled ? null : (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: isDisabled ? null : widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.xs,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: border,
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.labelLargeDesktop.copyWith(
              color: textColor,
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ),
      ),
    );
  }
}
