import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A set of mutually exclusive choices (e.g. profile type, plan '
      'selection). Exactly one option should have isSelected: true. '
      'The selected option is written to the data model at '
      '"/<componentId>/selectedLabel" so it is included automatically '
      'in the next interaction (e.g. a button tap).',
  properties: {
    'options': S.list(
      description: 'List of selectable radio card options.',
      items: S.object(
        properties: {
          'label': S.string(description: 'Text displayed on the card.'),
          'isSelected': S.boolean(
            description: 'Whether this option is selected.',
          ),
        },
        required: ['label', 'isSelected'],
      ),
    ),
  },
  required: ['options'],
);

/// CatalogItem that renders a list of [RadioCard] widgets.
///
/// Selection is bound to `/<componentId>/selectedLabel` via [BoundString].
final radioCardItem = CatalogItem(
  name: 'RadioCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawOptions = json['options']! as List;
    final options = rawOptions.cast<Map<String, Object?>>();

    return _BoundRadioCards(
      options: options,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _BoundRadioCards extends StatefulWidget {
  const _BoundRadioCards({
    required this.options,
    required this.dataContext,
    required this.componentId,
  });

  final List<Map<String, Object?>> options;
  final DataContext dataContext;
  final String componentId;

  @override
  State<_BoundRadioCards> createState() => _BoundRadioCardsState();
}

class _BoundRadioCardsState extends State<_BoundRadioCards> {
  DataPath get _path => DataPath('/${widget.componentId}/selectedLabel');

  @override
  void initState() {
    super.initState();
    _seedIfNeeded();
  }

  void _seedIfNeeded() {
    if (widget.dataContext.getValue<Object?>(_path) != null) return;
    final idx = widget.options.indexWhere((o) => o['isSelected'] == true);
    final i = idx >= 0 ? idx : 0;
    final label = widget.options[i]['label']! as String;
    widget.dataContext.update(_path, label);
  }

  int _selectedIndex(String? selectedLabel) {
    if (selectedLabel != null) {
      final idx = widget.options.indexWhere(
        (o) => o['label']! as String == selectedLabel,
      );
      if (idx >= 0) return idx;
    }
    final fallback = widget.options.indexWhere((o) => o['isSelected'] == true);
    if (fallback >= 0) return fallback;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: widget.dataContext,
      value: {'path': _path.toString()},
      builder: (context, selectedLabel) {
        final index = _selectedIndex(selectedLabel);
        return Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Spacing.xl,
          children: [
            for (var i = 0; i < widget.options.length; i++)
              RadioCard(
                label: widget.options[i]['label']! as String,
                isSelected: i == index,
                onTap: () {
                  widget.dataContext.update(
                    _path,
                    widget.options[i]['label']! as String,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
