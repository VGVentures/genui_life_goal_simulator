import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/bloc.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A section header with a title, subtitle, and an optional chip '
      'selector for switching between time ranges or views. '
      'Title and subtitle can be literal strings or data model bindings '
      '(e.g. {"path": "/<componentId>/value"}) to reactively display '
      'values from input widgets like GCNSlider. '
      'When selectorOptions is provided, the selected option is written to '
      'the data model at "/<componentId>/selectedOption" so it is included '
      'automatically in the next interaction. '
      'Optionally provide a "selectorAction" to dispatch an event when the '
      'selection changes, allowing the LLM to regenerate content.',
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'Main title text of the section.',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'Subtitle text displayed below the title.',
    ),
    'selectorOptions': S.list(
      items: S.string(),
      description:
          'Optional chip labels for the HeaderSelector '
          '(e.g. ["1M", "3M", "6M"]). Omit to hide the selector.',
    ),
    'selectedIndex': S.integer(
      description:
          'Zero-based index of the selected chip. '
          'Only relevant when selectorOptions is provided. Defaults to 0.',
      minimum: 0,
    ),
    'selectorAction': A2uiSchemas.action(
      description:
          'Optional action to dispatch when the selector changes. '
          'Use this to trigger the LLM to regenerate content for the '
          'new time period.',
    ),
  },
  required: ['title', 'subtitle'],
);

/// CatalogItem that renders a [SectionHeader] with an optional selector.
///
/// The `title` and `subtitle` properties support data model bindings via
/// `{"path": "..."}`, allowing them to reactively display values from input
/// widgets like GCNSlider.
///
/// When `selectorOptions` is provided, the selection is bound to
/// `/<componentId>/selectedOption`.
///
/// If a `selectorAction` is provided, it will be dispatched when the selector
/// changes, allowing the LLM to regenerate content for the new selection.
final sectionHeaderItem = CatalogItem(
  name: 'SectionHeader',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final titleValue = json['title']!;
    final subtitleValue = json['subtitle']!;
    final rawOptions = json['selectorOptions'] as List<Object?>?;
    final selectorOptions = rawOptions?.map((e) => e! as String).toList();
    final selectedIndex = (json['selectedIndex'] as num?)?.toInt() ?? 0;
    final selectorAction = json['selectorAction'] as Map<String, Object?>?;

    return _ActionLockSectionHeader(
      titleValue: titleValue,
      subtitleValue: subtitleValue,
      selectorOptions: selectorOptions,
      initialSelectedIndex: selectedIndex,
      selectorAction: selectorAction,
      dataContext: ctx.dataContext,
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _ActionLockSectionHeader extends StatefulWidget {
  const _ActionLockSectionHeader({
    required this.titleValue,
    required this.subtitleValue,
    required this.selectorOptions,
    required this.initialSelectedIndex,
    required this.selectorAction,
    required this.dataContext,
    required this.dispatchEvent,
    required this.componentId,
  });

  final Object titleValue;
  final Object subtitleValue;
  final List<String>? selectorOptions;
  final int initialSelectedIndex;
  final Map<String, Object?>? selectorAction;
  final DataContext dataContext;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_ActionLockSectionHeader> createState() =>
      _ActionLockSectionHeaderState();
}

class _ActionLockSectionHeaderState extends State<_ActionLockSectionHeader> {
  bool _tapped = false;

  DataPath get _path => DataPath('/${widget.componentId}/selectedOption');

  @override
  void initState() {
    super.initState();
    _seedIfNeeded();
  }

  void _seedIfNeeded() {
    final options = widget.selectorOptions;
    if (options == null || options.isEmpty) return;
    if (widget.dataContext.getValue<Object?>(_path) != null) return;
    final i = widget.initialSelectedIndex.clamp(0, options.length - 1);
    widget.dataContext.update(_path, options[i]);
  }

  int _selectedIndex(String? selectedOption) {
    final options = widget.selectorOptions!;
    if (selectedOption != null) {
      final idx = options.indexOf(selectedOption);
      if (idx >= 0) return idx;
    }
    if (options.isEmpty) return 0;
    return widget.initialSelectedIndex.clamp(0, options.length - 1);
  }

  void _onSelectorChanged(int index) {
    if (_tapped) return;

    final options = widget.selectorOptions!;
    widget.dataContext.update(_path, options[index]);

    final action = widget.selectorAction;
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

  Widget _buildSectionHeader({
    required String? title,
    required String? subtitle,
    required bool isDisabled,
    String? selectedOption,
  }) {
    final options = widget.selectorOptions;
    if (options == null || options.isEmpty) {
      return SectionHeader(
        title: title ?? '',
        subtitle: subtitle ?? '',
      );
    }

    final idx = _selectedIndex(selectedOption);

    return SectionHeader(
      title: title ?? '',
      subtitle: subtitle ?? '',
      selectorOptions: options,
      selectedIndex: idx,
      onSelectorChanged: isDisabled ? (_) {} : _onSelectorChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SimulatorBloc, SimulatorState>(
      listenWhen: (previous, current) =>
          previous.isLoading && !current.isLoading,
      listener: (context, state) => setState(() => _tapped = false),
      builder: (context, state) {
        final isDisabled = _tapped || state.isLoading;
        final options = widget.selectorOptions;
        final hasSelector = options != null && options.isNotEmpty;

        final sectionHeader = BoundString(
          dataContext: widget.dataContext,
          value: widget.titleValue,
          builder: (context, title) {
            return BoundString(
              dataContext: widget.dataContext,
              value: widget.subtitleValue,
              builder: (context, subtitle) {
                if (!hasSelector) {
                  return _buildSectionHeader(
                    title: title,
                    subtitle: subtitle,
                    isDisabled: isDisabled,
                  );
                }
                return BoundString(
                  dataContext: widget.dataContext,
                  value: {'path': _path.toString()},
                  builder: (context, selectedOption) {
                    return _buildSectionHeader(
                      title: title,
                      subtitle: subtitle,
                      isDisabled: isDisabled,
                      selectedOption: selectedOption,
                    );
                  },
                );
              },
            );
          },
        );

        if (!_tapped) return sectionHeader;

        return Stack(
          children: [
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: sectionHeader,
            ),
            const ThinkingAnimation(),
          ],
        );
      },
    );
  }
}
