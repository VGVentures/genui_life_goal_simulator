import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A white rounded card for grouping content sections on the summary '
      'screen. Use multiple SectionCards inside a SummaryContainer to '
      'visually separate different areas (e.g. one for metrics, one for '
      'a chart, one for product recommendations). Each card has a white '
      'background, 24px border radius, and 24px spacing below it.',
  properties: {
    'child': S.string(description: 'The ID of the child component.'),
  },
  required: ['child'],
);

/// A white rounded card for grouping content sections.
final sectionCardItem = CatalogItem(
  name: 'SectionCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final childId = json['child']! as String;

    return Builder(
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>();

        return Padding(
          padding: const EdgeInsets.only(bottom: Spacing.md),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors?.onPrimary ?? const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(Spacing.xl),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: ctx.buildChild(childId),
            ),
          ),
        );
      },
    );
  },
);
