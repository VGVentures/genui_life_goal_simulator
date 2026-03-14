import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A centered container for summary and analysis screens. '
      'Constrains content to 1000px max width with a branded background. '
      'Use this as the root component for the final summary step.',
  properties: {
    'child': S.string(description: 'The ID of the child component.'),
  },
  required: ['child'],
);

/// A 1000px-wide centered container for summary/analysis screens.
final summaryContainerItem = CatalogItem(
  name: 'SummaryContainer',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final childId = json['child']! as String;

    return Builder(
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>();

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors?.onPrimary ?? const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(Spacing.xs),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.lg),
                child: ctx.buildChild(childId),
              ),
            ),
          ),
        );
      },
    );
  },
);
