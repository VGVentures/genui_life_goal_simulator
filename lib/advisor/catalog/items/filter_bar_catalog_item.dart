import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

const _colorValues = [
  'pink',
  'mustard',
  'orange',
  'brightOrange',
  'deepRed',
  'plum',
  'aqua',
  'lightBlue',
  'lightOlive',
  'darkOlive',
  'emerald',
];

final _schema = S.object(
  description:
      'A horizontal bar of filter chips for narrowing data by category '
      '(e.g. spending categories, account types).',
  properties: {
    'categories': S.list(
      description: 'List of filter category chips to display.',
      items: S.object(
        properties: {
          'label': S.string(description: 'Display text for the chip.'),
          'color': S.string(
            description: 'Chip color.',
            enumValues: _colorValues,
          ),
          'isSelected': S.boolean(
            description: 'Whether the chip is selected.',
          ),
        },
        required: ['label', 'color', 'isSelected'],
      ),
    ),
  },
  required: ['categories'],
);

FilterChipColor _parseColor(String value) {
  return switch (value) {
    'mustard' => FilterChipColor.mustard,
    'orange' => FilterChipColor.orange,
    'brightOrange' => FilterChipColor.brightOrange,
    'deepRed' => FilterChipColor.deepRed,
    'plum' => FilterChipColor.plum,
    'aqua' => FilterChipColor.aqua,
    'lightBlue' => FilterChipColor.lightBlue,
    'lightOlive' => FilterChipColor.lightOlive,
    'darkOlive' => FilterChipColor.darkOlive,
    'emerald' => FilterChipColor.emerald,
    _ => FilterChipColor.pink,
  };
}

/// CatalogItem that renders a [FilterBar] widget.
final filterBarItem = CatalogItem(
  name: 'FilterBar',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCategories = json['categories']! as List;

    final categories = rawCategories.cast<Map<String, Object?>>().map((c) {
      return FilterCategory(
        label: c['label']! as String,
        color: _parseColor(c['color']! as String),
        isSelected: c['isSelected']! as bool,
      );
    }).toList();

    return FilterBar(
      categories: categories,
      onCategoryToggled: (_) {},
      onAllToggled: () {},
    );
  },
);
