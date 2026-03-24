import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:intl/intl.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A slider control for adjusting a numeric value within a range, '
      'such as a budget limit or spending target. '
      'The user adjusts the slider locally; the current value is written '
      'to the data model at "/<componentId>/value" (raw number) and '
      '"/<componentId>/formattedValue" (locale-formatted integer string '
      r'with optional prefix, e.g. "$72,000") so they are included '
      'automatically in the next interaction. Use formattedValue for '
      'display bindings. '
      'String fields support data model bindings via {"path": "..."}.',
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'Header title displayed above the slider.',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'Subtitle shown below the title (e.g. "Dining • Feb 18").',
    ),
    'value': S.number(
      description: 'Current slider value. Must be between min and max.',
    ),
    'min': S.number(description: 'Minimum slider value.'),
    'max': S.number(description: 'Maximum slider value.'),
    'prefix': S.string(
      description:
          r'Optional prefix prepended to formattedValue (e.g. "$", "€").',
    ),
    'valueLabel': A2uiSchemas.stringReference(
      description:
          r'Formatted value label shown at the top-right (e.g. "$450").',
    ),
    'minLabel': S.string(
      description: r'Label below track at the minimum end (e.g. "$1").',
    ),
    'maxLabel': S.string(
      description: r'Label below track at the maximum end (e.g. "$1270").',
    ),
    'divisions': S.number(
      description: 'Number of discrete divisions. Enables the splits variant.',
    ),
    'splitLabels': S.list(
      description:
          'Per-division labels for the splits variant. '
          'Should contain divisions + 1 elements.',
      items: S.string(),
    ),
  },
  required: ['title', 'subtitle', 'value', 'min', 'max'],
);

/// CatalogItem that renders a [GCNSlider] widget with local state management.
///
/// The slider value is managed locally and written to the data model at
/// `/<componentId>/value` so it is available when the user triggers a
/// subsequent action (e.g. tapping a "Next" button).
///
/// `title`, `subtitle`, and `valueLabel` support data model bindings.
final gcnSliderItem = CatalogItem(
  name: 'GCNSlider',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final initialValue = (json['value']! as num).toDouble();
    final min = (json['min']! as num).toDouble();
    final max = (json['max']! as num).toDouble();
    final divisions = (json['divisions'] as num?)?.toInt();
    final rawSplitLabels = json['splitLabels'] as List?;

    return _StatefulGCNSlider(
      titleValue: json['title']!,
      subtitleValue: json['subtitle']!,
      valueLabelValue: json['valueLabel'],
      initialValue: initialValue,
      min: min,
      max: max,
      prefix: json['prefix'] as String? ?? '',
      minLabel: json['minLabel'] as String?,
      maxLabel: json['maxLabel'] as String?,
      divisions: divisions,
      splitLabels: rawSplitLabels?.cast<String>(),
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _StatefulGCNSlider extends StatefulWidget {
  const _StatefulGCNSlider({
    required this.titleValue,
    required this.subtitleValue,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.dataContext,
    required this.componentId,
    required this.prefix,
    this.valueLabelValue,
    this.minLabel,
    this.maxLabel,
    this.divisions,
    this.splitLabels,
  });

  final Object titleValue;
  final Object subtitleValue;
  final Object? valueLabelValue;
  final double initialValue;
  final double min;
  final double max;
  final String prefix;
  final String? minLabel;
  final String? maxLabel;
  final int? divisions;
  final List<String>? splitLabels;
  final DataContext dataContext;
  final String componentId;

  @override
  State<_StatefulGCNSlider> createState() => _StatefulGCNSliderState();
}

class _StatefulGCNSliderState extends State<_StatefulGCNSlider> {
  late double _value;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _writeToDataModel(_value);
    }
  }

  String _formatValue(double value) {
    final locale = Localizations.maybeLocaleOf(context)?.toString();
    final number = NumberFormat.decimalPattern(locale).format(value.round());
    return '${widget.prefix}$number';
  }

  void _writeToDataModel(double value) {
    final formatted = _formatValue(value);

    widget.dataContext.update(
      DataPath('/${widget.componentId}/value'),
      value,
    );
    widget.dataContext.update(
      DataPath('/${widget.componentId}/formattedValue'),
      formatted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: widget.dataContext,
      value: widget.titleValue,
      builder: (context, title) {
        return BoundString(
          dataContext: widget.dataContext,
          value: widget.subtitleValue,
          builder: (context, subtitle) {
            // If the LLM provided a valueLabel (static or bound),
            // always show the locally formatted value so it updates
            // as the user drags.
            final showValueLabel = widget.valueLabelValue != null;

            return GCNSlider(
              title: title ?? '',
              subtitle: subtitle ?? '',
              value: _value,
              min: widget.min,
              max: widget.max,
              valueLabel: showValueLabel ? _formatValue(_value) : null,
              minLabel: widget.minLabel,
              maxLabel: widget.maxLabel,
              divisions: widget.divisions,
              splitLabels: widget.splitLabels,
              onChanged: (newValue) {
                setState(() => _value = newValue);
                _writeToDataModel(newValue);
              },
            );
          },
        );
      },
    );
  }
}
