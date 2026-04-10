import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/bloc.dart';
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

int _headerSelectedIndex(
  List<String> options,
  String? selectedOption,
  int initialSelectedIndex,
) {
  if (selectedOption != null) {
    final idx = options.indexOf(selectedOption);
    if (idx >= 0) return idx;
  }
  if (options.isEmpty) return 0;
  return initialSelectedIndex.clamp(0, options.length - 1);
}

/// CatalogItem that renders a [HeaderSelector].
///
/// The selection is bound to `/<componentId>/selectedOption` via [BoundString].
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

    return _ActionLockHeaderSelector(
      options: options,
      initialSelectedIndex: selectedIndex,
      action: action,
      dataContext: ctx.dataContext,
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _ActionLockHeaderSelector extends StatefulWidget {
  const _ActionLockHeaderSelector({
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
  State<_ActionLockHeaderSelector> createState() =>
      _ActionLockHeaderSelectorState();
}

class _ActionLockHeaderSelectorState extends State<_ActionLockHeaderSelector> {
  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _seedIfNeeded();
  }

  void _seedIfNeeded() {
    final path = DataPath('/${widget.componentId}/selectedOption');
    if (widget.dataContext.getValue<Object?>(path) != null) return;
    if (widget.options.isEmpty) return;
    final i = widget.initialSelectedIndex.clamp(0, widget.options.length - 1);
    widget.dataContext.update(path, widget.options[i]);
  }

  void _onChanged(int index) {
    if (_tapped) return;

    widget.dataContext.update(
      DataPath('/${widget.componentId}/selectedOption'),
      widget.options[index],
    );

    final action = widget.action;
    if (action case {'event': final Map<String, Object?> event}) {
      setState(() => _tapped = true);

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
    return BlocConsumer<SimulatorBloc, SimulatorState>(
      listenWhen: (previous, current) =>
          previous.isLoading && !current.isLoading,
      listener: (context, state) => setState(() => _tapped = false),
      builder: (context, state) {
        final isDisabled = _tapped || state.isLoading;
        final showThinking = _tapped;

        Widget selectorBuilder(BuildContext context, String? selectedOption) {
          final idx = _headerSelectedIndex(
            widget.options,
            selectedOption,
            widget.initialSelectedIndex,
          );

          return HeaderSelector(
            options: widget.options,
            selectedIndex: idx,
            onChanged: isDisabled ? (_) {} : _onChanged,
          );
        }

        final selector = BoundString(
          dataContext: widget.dataContext,
          value: {'path': '/${widget.componentId}/selectedOption'},
          builder: selectorBuilder,
        );

        if (!showThinking) return selector;

        return Stack(
          children: [
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: selector,
            ),
            const ThinkingAnimation(),
          ],
        );
      },
    );
  }
}
