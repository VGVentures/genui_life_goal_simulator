import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A set of mutually exclusive choices (e.g. profile type, plan '
      'selection). Exactly one option should have isSelected: true.',
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

/// CatalogItem that renders a list of [RadioCard] widgets.
final radioCardItem = CatalogItem(
  name: 'RadioCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawOptions = json['options']! as List;

    final cards = rawOptions.cast<Map<String, Object?>>().map((o) {
      return RadioCard(
        label: o['label']! as String,
        isSelected: o['isSelected']! as bool,
        onTap: () {},
      );
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.sm,
      children: cards,
    );
  },
);
