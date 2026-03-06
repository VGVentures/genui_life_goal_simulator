import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// Variants for the optional CTA button on an [ActionItem].
enum ActionItemButtonVariant {
  /// Filled button using the primary colour.
  primary,

  /// Outlined button with no background fill.
  secondary,

  /// No button is rendered.
  none,
}

/// {@template action_item}
/// A molecule widget that represents a single task or recommendation with an
/// optional CTA button.
///
/// Displays a [title] and [subtitle] on the left, an [amount] on the right,
/// and optionally a [delta] indicator and a CTA button.
///
/// Three button styles are supported via [buttonVariant]:
/// - [ActionItemButtonVariant.primary] – filled button.
/// - [ActionItemButtonVariant.secondary] – outlined button.
/// - [ActionItemButtonVariant.none] – no button (default).
///
/// Use [ActionItemsGroup] to render a stacked list of [ActionItem] widgets.
/// {@endtemplate}
class ActionItem extends StatelessWidget {
  /// {@macro action_item}
  const ActionItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    this.delta,
    this.buttonLabel,
    this.buttonVariant = ActionItemButtonVariant.none,
    this.onButtonTap,
    super.key,
  });

  /// Primary text, e.g. "Restaurant".
  final String title;

  /// Secondary text shown below [title], e.g. "Dining • Feb 18".
  final String subtitle;

  /// Monetary value shown on the trailing side, e.g. "\$450".
  final String amount;

  /// Optional change indicator shown below [amount], e.g. "+28%".
  final String? delta;

  /// Label for the CTA button; required when [buttonVariant] is not
  /// [ActionItemButtonVariant.none].
  final String? buttonLabel;

  /// Button style to render.
  final ActionItemButtonVariant buttonVariant;

  /// Called when the CTA button is tapped.
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
          child: Row(
            children: [
              Expanded(
                child: _ActionItemInfo(
                  title: title,
                  subtitle: subtitle,
                  textTheme: textTheme,
                  colors: colors,
                ),
              ),
              const SizedBox(width: Spacing.md),
              _ActionItemTrailing(
                amount: amount,
                delta: delta,
                buttonLabel: buttonLabel,
                buttonVariant: buttonVariant,
                onButtonTap: onButtonTap,
                textTheme: textTheme,
                colors: colors,
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: colors?.outlineVariant ?? _ActionItemColors.divider,
        ),
      ],
    );
  }
}

class _ActionItemInfo extends StatelessWidget {
  const _ActionItemInfo({
    required this.title,
    required this.subtitle,
    required this.textTheme,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final TextTheme textTheme;
  final AppColors? colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            color: colors?.onSurface ?? _ActionItemColors.title,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: _ActionItemDimensions.titleSubtitleGap),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: colors?.onSurfaceVariant ?? _ActionItemColors.subtitle,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ActionItemTrailing extends StatelessWidget {
  const _ActionItemTrailing({
    required this.amount,
    required this.delta,
    required this.buttonLabel,
    required this.buttonVariant,
    required this.onButtonTap,
    required this.textTheme,
    required this.colors,
  });

  final String amount;
  final String? delta;
  final String? buttonLabel;
  final ActionItemButtonVariant buttonVariant;
  final VoidCallback? onButtonTap;
  final TextTheme textTheme;
  final AppColors? colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amount,
              style: textTheme.bodyLarge?.copyWith(
                color: colors?.onSurface ?? _ActionItemColors.title,
              ),
            ),
            if (delta != null) ...[
              const SizedBox(height: _ActionItemDimensions.titleSubtitleGap),
              Text(
                delta!,
                style: textTheme.labelMedium?.copyWith(
                  color: colors?.success ?? _ActionItemColors.delta,
                ),
              ),
            ],
          ],
        ),
        if (buttonVariant != ActionItemButtonVariant.none &&
            buttonLabel != null) ...[
          const SizedBox(width: Spacing.md),
          _ActionButton(
            label: buttonLabel!,
            variant: buttonVariant,
            onTap: onButtonTap,
            colors: colors,
            textTheme: textTheme,
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.variant,
    required this.onTap,
    required this.colors,
    required this.textTheme,
  });

  final String label;
  final ActionItemButtonVariant variant;
  final VoidCallback? onTap;
  final AppColors? colors;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_ActionItemDimensions.buttonRadius),
    );

    return switch (variant) {
      ActionItemButtonVariant.primary => FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: colors?.primary,
          foregroundColor: colors?.onInverseSurface,
          shape: shape,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.lg,
            vertical: Spacing.xs,
          ),
          minimumSize: const Size(0, _ActionItemDimensions.buttonHeight),
          maximumSize: const Size(
            double.infinity,
            _ActionItemDimensions.buttonHeight,
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: colors?.onInverseSurface,
          ),
        ),
      ),
      ActionItemButtonVariant.secondary => OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors?.surfaceVariant,
          foregroundColor: colors?.onSurface,
          side: BorderSide(
            width: _ActionItemDimensions.secondaryBorderWidth,
            color: colors?.primary ?? _ActionItemColors.secondaryBorder,
          ),
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
          minimumSize: const Size(
            _ActionItemDimensions.secondaryButtonMinWidth,
            _ActionItemDimensions.buttonHeight,
          ),
          maximumSize: const Size(
            _ActionItemDimensions.secondaryButtonMaxWidth,
            _ActionItemDimensions.buttonHeight,
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: colors?.onSurface,
          ),
        ),
      ),
      ActionItemButtonVariant.none => const SizedBox.shrink(),
    };
  }
}

/// {@template action_items_group}
/// A composed widget that renders a vertical list of [ActionItem] widgets.
///
/// Each [ActionItem] renders its own bottom divider.
/// {@endtemplate}
class ActionItemsGroup extends StatelessWidget {
  /// {@macro action_items_group}
  const ActionItemsGroup({required this.items, super.key});

  /// The action items to display in order.
  final List<ActionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}

abstract final class _ActionItemDimensions {
  static const double buttonRadius = 100;
  static const double titleSubtitleGap = 2;
  static const double secondaryBorderWidth = 1.5;
  static const double buttonHeight = 45;
  static const double secondaryButtonMinWidth = 72;
  static const double secondaryButtonMaxWidth = 192;
}

abstract final class _ActionItemColors {
  static const Color title = Color(0xFF1A1C1C);
  static const Color subtitle = Color(0xFF5D5F5F);
  static const Color divider = Color(0xFFF0F1F1);
  static const Color delta = Color(0xFF00A65F);
  static const Color secondaryBorder = Color(0xFFE2E2E2);
}
