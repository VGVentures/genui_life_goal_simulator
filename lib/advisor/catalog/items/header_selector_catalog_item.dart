import 'package:finance_app/app/presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A group of chip-style toggles for switching between views or '
      'time periods (e.g. "1M", "3M", "6M"). '
      'Chips wrap to multiple lines if needed. '
      'The selected option is written to the data model at '
      '"/<componentId>/selectedOption" so it is included automatically '
      'in the next interaction.',
  properties: {
    'options': S.list(
      items: S.string(),
      description: 'Labels for each chip, e.g. ["1M", "3M", "6M"].',
    ),
    'selectedIndex': S.integer(
      description: 'Zero-based index of the currently selected chip.',
      minimum: 0,
    ),
  },
  required: ['options', 'selectedIndex'],
);

/// CatalogItem that renders a [HeaderSelector] with local state.
///
/// The selected index is managed locally and written to the data model at
/// `/<componentId>/selectedOption` so it is available when the user triggers
/// a subsequent action.
final headerSelectorItem = CatalogItem(
  name: 'HeaderSelector',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final options = (json['options']! as List<Object?>)
        .map((e) => e! as String)
        .toList();
    final selectedIndex = (json['selectedIndex']! as num).toInt();

    return _StatefulHeaderSelector(
      options: options,
      initialSelectedIndex: selectedIndex,
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _StatefulHeaderSelector extends StatefulWidget {
  const _StatefulHeaderSelector({
    required this.options,
    required this.initialSelectedIndex,
    required this.dataContext,
    required this.componentId,
  });

  final List<String> options;
  final int initialSelectedIndex;
  final DataContext dataContext;
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

  @override
  Widget build(BuildContext context) {
    return HeaderSelector(
      options: widget.options,
      selectedIndex: _selectedIndex,
      onChanged: (index) {
        setState(() => _selectedIndex = index);
        widget.dataContext.update(
          DataPath('/${widget.componentId}/selectedOption'),
          widget.options[index],
        );
      },
    );
  }
}
