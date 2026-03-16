import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

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
    final themeOf = Theme.of(context);
    final colorExtension = themeOf.extension<AppColors>();
    final textTheme = themeOf.textTheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Spacing.xs),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.xs),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorExtension?.primaryContainer
                : colorExtension?.onPrimary,
            borderRadius: BorderRadius.circular(Spacing.xs),
            border: Border.all(
              color: isSelected
                  ? colorExtension?.primary ?? Colors.transparent
                  : Colors.transparent,
            ),
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
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: colorExtension?.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IgnorePointer(
                    child: RadioGroup(
                      groupValue: isSelected,
                      onChanged: (_) {},
                      child: const Radio(
                        value: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
