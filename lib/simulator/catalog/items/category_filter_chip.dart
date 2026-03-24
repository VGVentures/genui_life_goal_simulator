import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final List<String> _colorValues = FilterChipColor.values
    .map((e) => e.name)
    .toList();

final _schema = S.object(
  description:
      'A toggleable filter chip for category selection '
      '(e.g. spending categories or tags). '
      'The selected state is written to the data model at '
      '"/<componentId>/isSelected" so it is included automatically '
      'in the next interaction.',
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

/// CatalogItem that renders a [CategoryFilterChip] with local state.
///
/// The selected state is managed locally and written to the data model at
/// `/<componentId>/isSelected` so it is available when the user triggers
/// a subsequent action.
final categoryFilterChipItem = CatalogItem(
  name: 'CategoryFilterChip',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final label = json['label']! as String;
    final colorRaw = json['color']! as String;
    final initialSelected = json['isSelected'] as bool? ?? false;
    final isEnabled = json['isEnabled'] as bool? ?? true;

    final color = FilterChipColor.values.firstWhere(
      (e) => e.name == colorRaw,
      orElse: () => FilterChipColor.aqua,
    );

    return _StatefulCategoryFilterChip(
      label: label,
      color: color,
      initialSelected: initialSelected,
      isEnabled: isEnabled,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _StatefulCategoryFilterChip extends StatefulWidget {
  const _StatefulCategoryFilterChip({
    required this.label,
    required this.color,
    required this.initialSelected,
    required this.isEnabled,
    required this.dataContext,
    required this.componentId,
  });

  final String label;
  final FilterChipColor color;
  final bool initialSelected;
  final bool isEnabled;
  final DataContext dataContext;
  final String componentId;

  @override
  State<_StatefulCategoryFilterChip> createState() =>
      _StatefulCategoryFilterChipState();
}

class _StatefulCategoryFilterChipState
    extends State<_StatefulCategoryFilterChip> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return CategoryFilterChip(
      label: widget.label,
      color: widget.color,
      isSelected: _isSelected,
      isEnabled: widget.isEnabled,
      onTap: () {
        setState(() => _isSelected = !_isSelected);
        widget.dataContext.update(
          DataPath('/${widget.componentId}/isSelected'),
          _isSelected,
        );
      },
    );
  }
}
