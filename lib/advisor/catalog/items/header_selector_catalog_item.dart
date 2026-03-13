import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A group of chip-style toggles for switching between views or '
      'time periods (e.g. "1M", "3M", "6M"). '
      'Chips wrap to multiple lines if needed.',
  properties: {
    'options': S.list(
      items: S.string(),
      description: 'Labels for each chip, e.g. ["1M", "3M", "6M"].',
    ),
    'selectedIndex': S.integer(
      description: 'Zero-based index of the currently selected chip.',
      minimum: 0,
    ),
    'action': A2uiSchemas.action(
      description: 'The action to perform when the user selects a chip.',
    ),
  },
  required: ['options', 'selectedIndex', 'action'],
);

/// CatalogItem that renders a display-only [HeaderSelector].
final headerSelectorItem = CatalogItem(
  name: 'HeaderSelector',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final options = (json['options']! as List<Object?>)
        .map((e) => e! as String)
        .toList();
    final selectedIndex = (json['selectedIndex']! as num).toInt();
    final action = json['action'] as Map<String, Object?>?;

    return HeaderSelector(
      options: options,
      selectedIndex: selectedIndex,
      onChanged: (index) {
        if (action case {'event': final Map<String, Object?> event}) {
          ctx.dispatchEvent(
            UserActionEvent(
              name: event['name']! as String,
              sourceComponentId: ctx.id,
              context: {
                ...event['context'] as Map<String, Object?>? ?? {},
                'selectedIndex': index,
                'selectedOption': options[index],
              },
            ),
          );
        }
      },
    );
  },
);
