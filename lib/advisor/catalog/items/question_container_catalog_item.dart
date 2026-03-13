import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A centered container for information-gathering screens. '
      'Constrains content to 650px max width. '
      'Use this as the root component during question steps.',
  properties: {
    'child': S.string(description: 'The ID of the child component.'),
  },
  required: ['child'],
);

/// A 650px-wide centered container for question/input screens.
final questionContainerItem = CatalogItem(
  name: 'QuestionContainer',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final childId = json['child']! as String;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: ctx.buildChild(childId),
      ),
    );
  },
);
