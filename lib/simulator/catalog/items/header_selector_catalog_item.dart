import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A group of chip-style toggles for switching between views or '
      'time periods (e.g. "1M", "3M", "6M"). '
      'Chips wrap to multiple lines if needed. '
      'The selected option is written to the data model at '
      '"/<componentId>/selectedOption" so it is included automatically '
      'in the next interaction. '
      'Optionally provide an "action" to dispatch an event when the '
      'selection changes, allowing the LLM to regenerate content.',
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
      description:
          'Optional action to dispatch when the selection changes. '
          'Use this to trigger the LLM to regenerate content for the '
          'new time period.',
    ),
  },
  required: ['options', 'selectedIndex'],
);

/// CatalogItem that renders a [HeaderSelector] with local state.
///
/// The selected index is managed locally and written to the data model at
/// `/<componentId>/selectedOption` so it is available when the user triggers
/// a subsequent action.
///
/// If an `action` is provided, it will be dispatched when the selection
/// changes, allowing the LLM to regenerate content for the new selection.
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

    return _StatefulHeaderSelector(
      options: options,
      initialSelectedIndex: selectedIndex,
      action: action,
      dataContext: ctx.dataContext,
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _StatefulHeaderSelector extends StatefulWidget {
  const _StatefulHeaderSelector({
    required this.options,
    required this.initialSelectedIndex,
    required this.action,
    required this.dataContext,
    required this.dispatchEvent,
    required this.componentId,
  });

  final List<String> options;
  final int initialSelectedIndex;
  final Map<String, Object?>? action;
  final DataContext dataContext;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_StatefulHeaderSelector> createState() =>
      _StatefulHeaderSelectorState();
}

class _StatefulHeaderSelectorState extends State<_StatefulHeaderSelector> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  void _onChanged(int index) {
    setState(() => _selectedIndex = index);

    final selectedOption = widget.options[index];
    widget.dataContext.update(
      DataPath('/${widget.componentId}/selectedOption'),
      selectedOption,
    );

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

  @override
  Widget build(BuildContext context) {
    return HeaderSelector(
      options: widget.options,
      selectedIndex: _selectedIndex,
      onChanged: _onChanged,
    );
  }
}
