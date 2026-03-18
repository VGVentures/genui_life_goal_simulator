import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

/// {@template header_selector}
/// A horizontal group of pill-shaped chips for selecting a time period.
///
/// Exactly one chip is selected at a time. Tapping a chip calls [onChanged]
/// with the index of the tapped chip. The selected chip is highlighted with
/// a primary-blue background; unselected chips use a neutral surface style.
///
/// On pointer-capable devices, hovering a chip applies a tinted background
/// with a primary border.
/// {@endtemplate}
class HeaderSelector extends StatelessWidget {
  /// {@macro header_selector}
  const HeaderSelector({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  /// Labels displayed as individual chips (e.g. `['1M', '3M', '6M']`).
  final List<String> options;

  /// Index of the currently selected chip.
  final int selectedIndex;

  /// Called with the index of the chip that was tapped.
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Spacing.xs,
      runSpacing: Spacing.xs,
      children: [
        for (final (i, label) in options.indexed)
          _HeaderSelectorChip(
            label: label,
            isSelected: i == selectedIndex,
            onTap: () => onChanged(i),
          ),
      ],
    );
  }
}

class _HeaderSelectorChip extends StatefulWidget {
  const _HeaderSelectorChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_HeaderSelectorChip> createState() => _HeaderSelectorChipState();
}

class _HeaderSelectorChipState extends State<_HeaderSelectorChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorExtension = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    final Color backgroundColor;
    final Color borderColor;
    final Color textColor;

    if (widget.isSelected) {
      backgroundColor = colorExtension?.primary ?? _ChipColors.selected;
      borderColor = Colors.transparent;
      textColor = colorExtension?.onPrimary ?? Colors.white;
    } else if (_isHovered) {
      backgroundColor = colorExtension?.primaryContainer ?? _ChipColors.hovered;
      borderColor = colorExtension?.primary ?? _ChipColors.selected;
      textColor = colorExtension?.onSurfaceVariant ?? _ChipColors.text;
    } else {
      backgroundColor = colorExtension?.surface ?? _ChipColors.surface;
      borderColor = colorExtension?.outlineVariant ?? _ChipColors.border;
      textColor = colorExtension?.onSurfaceVariant ?? _ChipColors.text;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(_Dimensions.borderRadius),
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.xs,
              ),
              child: Text(
                widget.label,
                style: textTheme.labelLarge?.copyWith(
                  color: textColor,
                  letterSpacing: _Dimensions.letterSpacing,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class _Dimensions {
  static const double borderRadius = 32;
  static const double letterSpacing = -0.15;
}

abstract final class _ChipColors {
  static const Color selected = Color(0xFF6D92F5);
  static const Color surface = Color(0xFFF7F6F7);
  static const Color border = Color(0xFFE2E2E2);
  static const Color hovered = Color(0xFFF3F6FF);
  static const Color text = Color(0xFF5D5F5F);
}
