import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

/// {@template radio_card}
/// A tappable card that displays a [label] with a [Radio] indicator.
///
/// Visually toggles between selected and unselected states based on
/// [isSelected]. The selected state applies a highlighted background
/// and a colored border; the unselected state uses a neutral background
/// with a transparent border.
///
/// The [Radio] is wrapped in [IgnorePointer] so that taps are handled
/// exclusively by the card's [InkWell] via [onTap].
/// {@endtemplate}
class RadioCard extends StatelessWidget {
  /// {@macro radio_card}
  const RadioCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  /// The text displayed at the top of the card.
  final String label;

  /// Whether the card is in the selected state.
  final bool isSelected;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _RadioCardContent(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
    );
  }
}

class _RadioCardContent extends StatefulWidget {
  const _RadioCardContent({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_RadioCardContent> createState() => _RadioCardContentState();
}

class _RadioCardContentState extends State<_RadioCardContent> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeOf = Theme.of(context);
    final colorExtension = themeOf.extension<AppColors>();
    final textTheme = themeOf.textTheme;

    final Color backgroundColor;
    final Color borderColor;

    if (widget.isSelected) {
      backgroundColor = colorExtension?.primaryContainer ?? Colors.transparent;
      borderColor = colorExtension?.primary ?? Colors.transparent;
    } else if (_isHovered) {
      backgroundColor = Color.alphaBlend(
        colorExtension?.primary.withValues(alpha: 0.05) ?? Colors.transparent,
        colorExtension?.surfaceVariant ?? Colors.white,
      );
      borderColor = colorExtension?.outlineVariant ?? Colors.transparent;
    } else {
      backgroundColor = colorExtension?.surfaceVariant ?? Colors.transparent;
      borderColor = colorExtension?.surfaceVariant ?? Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Spacing.xs),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(Spacing.xs),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(Spacing.xs),
              border: Border.all(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.sm,
                horizontal: Spacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.label,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorExtension?.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RadioGroup(
                      groupValue: widget.isSelected,
                      onChanged: (_) => widget.onTap(),
                      child: const Radio(
                        value: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
