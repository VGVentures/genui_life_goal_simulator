import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
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
      '(e.g. spending categories, account types). '
      'The selected categories are written to the data model at '
      '"/<componentId>/selectedCategories" so they are included '
      'automatically in the next interaction.',
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

/// CatalogItem that renders a [FilterBar] with local state.
///
/// The selected categories are managed locally and written to the data model at
/// `/<componentId>/selectedCategories` so they are available when the user
/// triggers a subsequent action.
final filterBarItem = CatalogItem(
  name: 'FilterBar',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawCategories = json['categories']! as List;
    final parsed = rawCategories.cast<Map<String, Object?>>().map((c) {
      return (
        label: c['label']! as String,
        color: _parseColor(c['color']! as String),
        isSelected: c['isSelected']! as bool,
      );
    }).toList();

    return _StatefulFilterBar(
      categories: parsed,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _StatefulFilterBar extends StatefulWidget {
  const _StatefulFilterBar({
    required this.categories,
    required this.dataContext,
    required this.componentId,
  });

  final List<({String label, FilterChipColor color, bool isSelected})>
  categories;
  final DataContext dataContext;
  final String componentId;

  @override
  State<_StatefulFilterBar> createState() => _StatefulFilterBarState();
}

class _StatefulFilterBarState extends State<_StatefulFilterBar> {
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.categories.map((c) => c.isSelected).toList();
  }

  void _writeToDataModel() {
    final selectedLabels = [
      for (var i = 0; i < widget.categories.length; i++)
        if (_selected[i]) widget.categories[i].label,
    ];
    widget.dataContext.update(
      DataPath('/${widget.componentId}/selectedCategories'),
      selectedLabels,
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      for (var i = 0; i < widget.categories.length; i++)
        FilterCategory(
          label: widget.categories[i].label,
          color: widget.categories[i].color,
          isSelected: _selected[i],
        ),
    ];

    return FilterBar(
      categories: categories,
      onCategoryToggled: (index) {
        setState(() => _selected[index] = !_selected[index]);
        _writeToDataModel();
      },
      onAllToggled: () {
        final allSelected = _selected.every((s) => s);
        setState(() {
          for (var i = 0; i < _selected.length; i++) {
            _selected[i] = !allSelected;
          }
        });
        _writeToDataModel();
      },
    );
  }
}
