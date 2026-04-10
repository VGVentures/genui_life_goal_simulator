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

void _seedChipIsSelectedIfNeeded(
  CatalogItemContext ctx,
  bool initialSelected,
) {
  final path = DataPath('/${ctx.id}/isSelected');
  if (ctx.dataContext.getValue<Object?>(path) != null) return;
  ctx.dataContext.update(path, initialSelected);
}

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

    _seedChipIsSelectedIfNeeded(ctx, initialSelected);

    return BoundBool(
      dataContext: ctx.dataContext,
      value: {'path': '/${ctx.id}/isSelected'},
      builder: (context, isSelected) {
        final selected = isSelected ?? false;
        return CategoryFilterChip(
          label: label,
          color: color,
          isSelected: selected,
          isEnabled: isEnabled,
          onTap: () {
            ctx.dataContext.update(
              DataPath('/${ctx.id}/isSelected'),
              !selected,
            );

            if (action case {'event': final Map<String, Object?> event}) {
              final dataModel = ctx.dataContext.dataModel
                  .getValue<Map<String, Object?>>(DataPath.root);

              ctx.dispatchEvent(
                UserActionEvent(
                  name: event['name']! as String,
                  sourceComponentId: ctx.id,
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
  },
);
