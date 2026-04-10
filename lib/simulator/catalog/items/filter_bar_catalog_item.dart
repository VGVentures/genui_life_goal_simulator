import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/bloc.dart';
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
      'automatically in the next interaction. '
      'Optionally provide an "action" to dispatch an event when the '
      'selection changes, allowing the LLM to regenerate content.',
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
    'action': A2uiSchemas.action(
      description:
          'Optional action to dispatch when the filter selection changes. '
          'Use this to trigger the LLM to regenerate content for the '
          'new filter selection.',
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

/// CatalogItem that renders a [FilterBar].
///
/// Selection is bound to `/<componentId>/selectedCategories` via [BoundList].
///
/// If an `action` is provided, it will be dispatched when the filter selection
/// changes, allowing the LLM to regenerate content for the new selection.
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
    final action = json['action'] as Map<String, Object?>?;

    return _ActionLockFilterBar(
      categories: parsed,
      action: action,
      dataContext: ctx.dataContext,
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _ActionLockFilterBar extends StatefulWidget {
  const _ActionLockFilterBar({
    required this.categories,
    required this.action,
    required this.dataContext,
    required this.dispatchEvent,
    required this.componentId,
  });

  final List<({String label, FilterChipColor color, bool isSelected})>
  categories;
  final Map<String, Object?>? action;
  final DataContext dataContext;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_ActionLockFilterBar> createState() => _ActionLockFilterBarState();
}

class _ActionLockFilterBarState extends State<_ActionLockFilterBar> {
  bool _tapped = false;

  DataPath get _path => DataPath('/${widget.componentId}/selectedCategories');

  @override
  void initState() {
    super.initState();
    _seedIfNeeded();
  }

  void _seedIfNeeded() {
    if (widget.dataContext.getValue<Object?>(_path) != null) return;
    final labels = [
      for (final c in widget.categories)
        if (c.isSelected) c.label,
    ];
    widget.dataContext.update(_path, labels);
  }

  void _dispatchAction() {
    final action = widget.action;
    if (action case {'event': final Map<String, Object?> event}) {
      final dataModel = widget.dataContext.dataModel
          .getValue<Map<String, Object?>>(DataPath.root);

      widget.dispatchEvent(
        UserActionEvent(
          name: event['name']! as String,
          sourceComponentId: widget.componentId,
          context: {
            ...event['context'] as Map<String, Object?>? ?? {},
            if (dataModel != null) ...dataModel,
          },
        ),
      );
    }
  }

  void _onFilterChanged() {
    if (_tapped) return;
    if (widget.action != null) {
      setState(() => _tapped = true);
    }
    _dispatchAction();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SimulatorBloc, SimulatorState>(
      listenWhen: (previous, current) =>
          previous.isLoading && !current.isLoading,
      listener: (context, state) => setState(() => _tapped = false),
      builder: (context, state) {
        final isDisabled = _tapped || state.isLoading;
        final showThinking = _tapped;

        Widget listBuilder(
          BuildContext context,
          List<Object?>? rawSelected,
        ) {
          final currentList = [
            for (final e in rawSelected ?? const <Object?>[])
              if (e != null) e.toString(),
          ];
          final selectedSet = currentList.toSet();

          final categories = [
            for (var i = 0; i < widget.categories.length; i++)
              FilterCategory(
                label: widget.categories[i].label,
                color: widget.categories[i].color,
                isSelected: selectedSet.contains(widget.categories[i].label),
                isEnabled: !isDisabled,
              ),
          ];

          void writeList(List<String> next) {
            widget.dataContext.update(_path, next);
          }

          return FilterBar(
            categories: categories,
            isAllEnabled: !isDisabled,
            onCategoryToggled: (index) {
              if (isDisabled) return;
              final label = widget.categories[index].label;
              final next = List<String>.from(currentList);
              if (next.contains(label)) {
                next.remove(label);
              } else {
                next.add(label);
              }
              writeList(next);
              _onFilterChanged();
            },
            onAllToggled: () {
              if (isDisabled) return;
              final allSelected = widget.categories.every(
                (c) => selectedSet.contains(c.label),
              );
              if (allSelected) {
                writeList([]);
              } else {
                writeList([
                  for (final c in widget.categories) c.label,
                ]);
              }
              _onFilterChanged();
            },
          );
        }

        final filterBar = BoundList(
          dataContext: widget.dataContext,
          value: {'path': _path.toString()},
          builder: listBuilder,
        );

        if (!showThinking) return filterBar;

        return Stack(
          children: [
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: filterBar,
            ),
            const ThinkingAnimation(),
          ],
        );
      },
    );
  }
}
