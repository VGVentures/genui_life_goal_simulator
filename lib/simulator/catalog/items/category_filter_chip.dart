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
      'in the next interaction. '
      'Optionally provide an "action" to dispatch an event when toggled, '
      'allowing the LLM to regenerate content.',
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
    'action': A2uiSchemas.action(
      description:
          'Optional action to dispatch when the chip is toggled. '
          'Use this to trigger the LLM to regenerate content.',
    ),
  },
  required: ['label', 'color'],
);

/// CatalogItem that renders a [CategoryFilterChip].
///
/// The selected state is bound to `/<componentId>/isSelected` via [BoundBool].
///
/// If an `action` is provided, it will be dispatched when the chip is toggled,
/// allowing the LLM to regenerate content.
final categoryFilterChipItem = CatalogItem(
  name: 'CategoryFilterChip',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final label = json['label']! as String;
    final colorRaw = json['color']! as String;
    final initialSelected = json['isSelected'] as bool? ?? false;
    final isEnabled = json['isEnabled'] as bool? ?? true;
    final action = json['action'] as Map<String, Object?>?;

    final color = FilterChipColor.values.firstWhere(
      (e) => e.name == colorRaw,
      orElse: () => FilterChipColor.aqua,
    );

    return _BoundCategoryFilterChip(
      label: label,
      color: color,
      initialSelected: initialSelected,
      isEnabled: isEnabled,
      action: action,
      dataContext: ctx.dataContext,
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _BoundCategoryFilterChip extends StatefulWidget {
  const _BoundCategoryFilterChip({
    required this.label,
    required this.color,
    required this.initialSelected,
    required this.isEnabled,
    required this.action,
    required this.dataContext,
    required this.dispatchEvent,
    required this.componentId,
  });

  final String label;
  final FilterChipColor color;
  final bool initialSelected;
  final bool isEnabled;
  final Map<String, Object?>? action;
  final DataContext dataContext;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_BoundCategoryFilterChip> createState() =>
      _BoundCategoryFilterChipState();
}

class _BoundCategoryFilterChipState extends State<_BoundCategoryFilterChip> {
  DataPath get _path => DataPath('/${widget.componentId}/isSelected');

  @override
  void initState() {
    super.initState();
    _seedIfNeeded();
  }

  void _seedIfNeeded() {
    if (widget.dataContext.getValue<Object?>(_path) != null) return;
    widget.dataContext.update(_path, widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return BoundBool(
      dataContext: widget.dataContext,
      value: {'path': _path.toString()},
      builder: (context, isSelected) {
        final selected = isSelected ?? false;
        return CategoryFilterChip(
          label: widget.label,
          color: widget.color,
          isSelected: selected,
          isEnabled: widget.isEnabled,
          onTap: () {
            widget.dataContext.update(_path, !selected);

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
          },
        );
      },
    );
  }
}
