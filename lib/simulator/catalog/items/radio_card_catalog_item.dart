import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A set of mutually exclusive choices (e.g. profile type, plan '
      'selection). Exactly one option should have isSelected: true. '
      'The selected option is written to the data model at '
      '"/<componentId>/selectedLabel" so it is included automatically '
      'in the next interaction (e.g. a button tap).',
  properties: {
    'options': S.list(
      description: 'List of selectable radio card options.',
      items: S.object(
        properties: {
          'label': S.string(description: 'Text displayed on the card.'),
          'isSelected': S.boolean(
            description: 'Whether this option is selected.',
          ),
        },
        required: ['label', 'isSelected'],
      ),
    ),
  },
  required: ['options'],
);

void _seedRadioSelectedLabelIfNeeded(
  CatalogItemContext ctx,
  List<Map<String, Object?>> options,
) {
  final path = DataPath('/${ctx.id}/selectedLabel');
  if (ctx.dataContext.getValue<Object?>(path) != null) return;
  final idx = options.indexWhere((o) => o['isSelected'] == true);
  final i = idx >= 0 ? idx : 0;
  final label = options[i]['label']! as String;
  ctx.dataContext.update(path, label);
}

int _radioSelectedIndex(
  List<Map<String, Object?>> options,
  String? selectedLabel,
) {
  if (selectedLabel != null) {
    final idx = options.indexWhere(
      (o) => o['label']! as String == selectedLabel,
    );
    if (idx >= 0) return idx;
  }
  final fallback = options.indexWhere((o) => o['isSelected'] == true);
  if (fallback >= 0) return fallback;
  return 0;
}

/// CatalogItem that renders a list of [RadioCard] widgets.
///
/// Selection is bound to `/<componentId>/selectedLabel` via [BoundString].
final radioCardItem = CatalogItem(
  name: 'RadioCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawOptions = json['options']! as List;
    final options = rawOptions.cast<Map<String, Object?>>();

    _seedRadioSelectedLabelIfNeeded(ctx, options);

    return BoundString(
      dataContext: ctx.dataContext,
      value: {'path': '/${ctx.id}/selectedLabel'},
      builder: (context, selectedLabel) {
        final index = _radioSelectedIndex(options, selectedLabel);
        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xl,
          children: [
            for (var i = 0; i < options.length; i++)
              RadioCard(
                label: options[i]['label']! as String,
                isSelected: i == index,
                onTap: () {
                  ctx.dataContext.update(
                    DataPath('/${ctx.id}/selectedLabel'),
                    options[i]['label']! as String,
                  );
                },
              ),
          ],
        );
      },
    );
  },
);
