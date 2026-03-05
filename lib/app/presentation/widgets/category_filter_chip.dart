import 'package:finance_app/app/presentation/app_colors.dart';
import 'package:finance_app/app/presentation/app_text_styles.dart';
import 'package:finance_app/app/presentation/filter_chip_color.dart';
import 'package:flutter/material.dart';

export 'package:finance_app/app/presentation/filter_chip_color.dart';

class CategoryFilterChip extends StatefulWidget {
  const CategoryFilterChip({
    required this.color,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.isEnabled = true,
    super.key,
  });

  final FilterChipColor color;
  final String label;

  final bool? isSelected;

  final VoidCallback? onTap;
  final bool isEnabled;

  @override
  State<CategoryFilterChip> createState() => _CategoryFilterChipState();
}

class _CategoryFilterChipState extends State<CategoryFilterChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
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
          alpha: _Dimensions.hoveredOpacity,
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
          constraints: const BoxConstraints(minWidth: _Dimensions.minWidth),
          padding: const EdgeInsets.symmetric(
            horizontal: _Dimensions.horizontalPadding,
            vertical: _Dimensions.verticalPadding,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
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

abstract final class _Dimensions {
  static const double minWidth = 116;
  static const double borderRadius = 32;
  static const double horizontalPadding = 16;
  static const double verticalPadding = 8;
  static const double hoveredOpacity = 0.15;
}
