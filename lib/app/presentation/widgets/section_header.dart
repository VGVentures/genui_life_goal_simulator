import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template section_header}
/// A section header molecule used across multiple screens for consistent
/// section labeling.
///
/// Displays a title and optional subtitle with an optional [HeaderSelector]
/// for time period selection. The layout adapts responsively:
/// - On desktop (>= 600px): horizontal layout with selector on the right
/// - On mobile (< 600px): vertical layout with selector below the title
/// {@endtemplate}
class SectionHeader extends StatelessWidget {
  /// {@macro section_header}
  const SectionHeader({
    required this.title,
    required this.subtitle,
    this.selectorOptions,
    this.selectedIndex = 0,
    this.onSelectorChanged,
    super.key,
  });

  /// The main title text displayed in the header.
  final String title;

  /// Subtitle text displayed below the title.
  final String subtitle;

  /// Labels for the selector chips (e.g. `['1M', '3M', '6M']`).
  /// If null, no selector is displayed.
  final List<String>? selectorOptions;

  /// Index of the currently selected chip.
  final int selectedIndex;

  /// Called with the index of the chip that was tapped.
  final ValueChanged<int>? onSelectorChanged;

  @override
  Widget build(BuildContext context) {
    final colorExtension = Theme.of(context).extension<AppColors>();
    final textTheme = Theme.of(context).textTheme;
    final isDesktop = !Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    final titleText = Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorExtension?.onSurface ?? _DefaultColors.title,
      ),
    );

    final subtitleText = Text(
      subtitle,
      style: textTheme.bodyMedium?.copyWith(
        color: colorExtension?.onSurfaceVariant ?? _DefaultColors.subtitle,
      ),
    );

    final selector = selectorOptions != null && selectorOptions!.isNotEmpty
        ? HeaderSelector(
            options: selectorOptions!,
            selectedIndex: selectedIndex,
            onChanged: onSelectorChanged ?? (_) {},
          )
        : null;

    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleText,
        const SizedBox(height: Spacing.xxs),
        subtitleText,
      ],
    );

    late Widget content;

    if (selector == null) {
      content = titleColumn;
    } else if (isDesktop) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: titleColumn),
          selector,
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          titleColumn,
          const SizedBox(height: Spacing.sm),
          selector,
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: content,
    );
  }
}

abstract final class _DefaultColors {
  static const Color title = Color(0xFF1A1C1C);
  static const Color subtitle = Color(0xFF5D5F5F);
}
