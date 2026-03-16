import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
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

/// CatalogItem that renders a list of [RadioCard] widgets with local state.
///
/// The selected option is managed locally and written to the data model at
/// `/<componentId>/selectedLabel` so it is available when the user triggers a
/// subsequent action (e.g. tapping a "Next" button).
final radioCardItem = CatalogItem(
  name: 'RadioCard',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawOptions = json['options']! as List;
    final options = rawOptions.cast<Map<String, Object?>>();

    return _StatefulRadioCards(
      options: options,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _StatefulRadioCards extends StatefulWidget {
  const _StatefulRadioCards({
    required this.options,
    required this.dataContext,
    required this.componentId,
  });

  final List<Map<String, Object?>> options;
  final DataContext dataContext;
  final String componentId;

  @override
  State<_StatefulRadioCards> createState() => _StatefulRadioCardsState();
}

class _StatefulRadioCardsState extends State<_StatefulRadioCards> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.options.indexWhere(
      (o) => o['isSelected'] == true,
    );
    if (_selectedIndex == -1) _selectedIndex = 0;
  }

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
    final label = widget.options[index]['label']! as String;
    widget.dataContext.update(
      DataPath('/${widget.componentId}/selectedLabel'),
      label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.xl,
      children: [
        for (var i = 0; i < widget.options.length; i++)
          RadioCard(
            label: widget.options[i]['label']! as String,
            isSelected: i == _selectedIndex,
            onTap: () => _onTap(i),
          ),
      ],
    );
  }
}
