import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final List<String> _colorValues = FilterChipColor.values
    .map((e) => e.name)
    .toList();

final _schema = S.object(
  description:
      'A toggleable filter chip for category selection '
      '(e.g. spending categories or tags).',
  properties: {
    'label': S.string(description: 'Text displayed inside the chip.'),
    'color': S.string(
      description: 'Chip accent color.',
      enumValues: _colorValues,
    ),
    'isSelected': S.boolean(
      description: 'Whether the chip appears in its selected state.',
    ),
    'isEnabled': S.boolean(
      description:
          'Whether the chip is interactive. Defaults to true. '
          'Set to false to render the chip in a disabled/muted state.',
    ),
  },
  required: ['label', 'color'],
);

/// CatalogItem that renders a display-only [CategoryFilterChip].
final categoryFilterChipItem = CatalogItem(
  name: 'CategoryFilterChip',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final label = json['label']! as String;
    final colorRaw = json['color']! as String;
    final isSelected = json['isSelected'] as bool? ?? false;
    final isEnabled = json['isEnabled'] as bool? ?? true;

    final color = FilterChipColor.values.firstWhere(
      (e) => e.name == colorRaw,
      orElse: () => FilterChipColor.aqua,
    );

    return CategoryFilterChip(
      label: label,
      color: color,
      isSelected: isSelected,
      isEnabled: isEnabled,
      onTap: () {},
    );
  },
);
