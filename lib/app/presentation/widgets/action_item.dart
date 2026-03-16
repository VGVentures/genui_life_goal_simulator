import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template action_item}
/// A molecule widget that represents a single task or recommendation with an
/// optional trailing widget.
///
/// Displays a [title] and [subtitle] on the left, an [amount] on the right,
/// and optionally a [delta] indicator and a [trailing] widget (e.g. a button).
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
    this.trailing,
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

  /// Optional widget rendered after the amount/delta area (e.g. a button).
  final Widget? trailing;

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
                trailing: trailing,
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
    required this.trailing,
    required this.textTheme,
    required this.colors,
  });

  final String amount;
  final String? delta;
  final Widget? trailing;
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
        if (trailing != null) ...[
          const SizedBox(width: Spacing.md),
          trailing!,
        ],
      ],
    );
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
  static const double titleSubtitleGap = 2;
}

abstract final class _ActionItemColors {
  static const Color title = Color(0xFF1A1C1C);
  static const Color subtitle = Color(0xFF5D5F5F);
  static const Color divider = Color(0xFFF0F1F1);
  static const Color delta = Color(0xFF00A65F);
}
