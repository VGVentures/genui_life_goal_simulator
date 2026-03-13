import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A centered container for summary and analysis screens. '
      'Constrains content to 1000px max width. '
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ctx.buildChild(childId),
      ),
    );
  },
);
