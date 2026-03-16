import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A centered container that constrains content to 650px max width. '
      'Use this as the root component for ALL screens except the final '
      'summary. This includes welcome, questions, information gathering, '
      'and any intermediate steps.',
  properties: {
    'child': S.string(description: 'The ID of the child component.'),
  },
  required: ['child'],
);

/// A 650px-wide centered container for all non-summary screens.
final questionContainerItem = CatalogItem(
  name: 'QuestionContainer',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final childId = json['child']! as String;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: SizedBox(
          width: double.infinity,
          child: ctx.buildChild(childId),
        ),
      ),
    );
  },
);
