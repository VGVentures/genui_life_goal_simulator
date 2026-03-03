import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

class RadioCard extends StatelessWidget {
  const RadioCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
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
                ? colorExtension?.secondary.shade800
                : colorExtension?.secondary.shade100,
            borderRadius: BorderRadius.circular(Spacing.xs),
            border: Border.all(
              color: isSelected
                  ? colorExtension?.secondary.shade600 ?? Colors.transparent
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
                    color: colorExtension?.primary.shade500,
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
