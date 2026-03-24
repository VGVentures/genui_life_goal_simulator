import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A centered container for summary and analysis screens. '
      'Constrains content to 1000px max width. '
      'Use this as the root component for the final summary step. '
      'Place SectionCard widgets inside for grouped content areas. '
      'Use bottomBar to add a NextStepsBar at the end of the content.',
  properties: {
    'child': S.string(description: 'The ID of the child component.'),
    'bottomBar': S.string(
      description:
          'Optional component ID for a bar at the bottom '
          '(e.g. a NextStepsBar).',
    ),
  },
  required: ['child'],
);

/// A 1000px-wide centered container for summary/analysis screens.
///
/// When `bottomBar` is provided, it renders after the main content.
final CatalogItem summaryContainerItem = CatalogItem(
  name: 'SummaryContainer',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final childId = json['child']! as String;
    final bottomBarId = json['bottomBar'] as String?;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ctx.buildChild(childId),
              if (bottomBarId != null) ctx.buildChild(bottomBarId),
            ],
          ),
        ),
      ),
    );
  },
);
