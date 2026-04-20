import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

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
    this.borderRadius = 32,
    super.key,
  });

  /// Labels displayed as individual chips (e.g. `['1M', '3M', '6M']`).
  final List<String> options;

  /// Index of the currently selected chip.
  final int selectedIndex;

  /// Called with the index of the chip that was tapped.
  final ValueChanged<int> onChanged;

  /// Corner radius of each pill-shaped chip.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Wrap(
        spacing: Spacing.xs,
        runSpacing: Spacing.xs,
        children: [
          for (final (i, label) in options.indexed)
            _HeaderSelectorChip(
              label: label,
              isSelected: i == selectedIndex,
              onTap: () => onChanged(i),
              borderRadius: borderRadius,
            ),
        ],
      ),
    );
  }
}

class _HeaderSelectorChip extends StatefulWidget {
  const _HeaderSelectorChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.borderRadius,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double borderRadius;

  @override
  State<_HeaderSelectorChip> createState() => _HeaderSelectorChipState();
}

class _HeaderSelectorChipState extends State<_HeaderSelectorChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final Color backgroundColor;
    final Color borderColor;
    final Color textColor;

    if (widget.isSelected) {
      backgroundColor = colors.primary;
      borderColor = Colors.transparent;
      textColor = colors.onPrimary;
    } else if (_isHovered) {
      backgroundColor = colors.primaryContainer;
      borderColor = colors.primary;
      textColor = colors.onSurfaceVariant;
    } else {
      backgroundColor = colors.surface;
      borderColor = colors.outlineVariant;
      textColor = colors.onSurfaceVariant;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
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
                  letterSpacing: -0.15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
