import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:intl/intl.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// How the slider's current value is formatted for display.
enum SliderFormatter {
  /// US dollars, whole amount only (e.g. "$72,000").
  usd,

  /// Percentage with up to one decimal place (e.g. "10.1%", "50%").
  percentage,

  /// Plain integer (e.g. "42").
  integer,
}

final _schema = S.object(
  description:
      'A slider control for adjusting a numeric value within a range, '
      'such as a budget limit or spending target. '
      'The current value is stored in the data model at default path '
      '"/<componentId>/value" (raw number). '
      'The value field may be a literal number, a binding {"path": "..."}, '
      'or a function call. String fields use {"path": "..."} bindings.',
  properties: {
    'title': A2uiSchemas.stringReference(
      description: 'Header title displayed above the slider.',
    ),
    'subtitle': A2uiSchemas.stringReference(
      description: 'Subtitle shown below the title (e.g. "Dining • Feb 18").',
    ),
    'value': A2uiSchemas.numberReference(
      description:
          'Current slider value: literal number, {"path": "..."}, or '
          'function. Must stay between min and max. If omitted from the '
          'model at the bound path, a literal (when provided) initializes '
          'the default path "/<componentId>/value".',
    ),
    'min': S.number(description: 'Minimum slider value.'),
    'max': S.number(description: 'Maximum slider value.'),
    'formatter': S.string(
      description:
          'Optional. Controls how the current value is displayed at the '
          'top-right of the slider. '
          r'"usd" → whole US dollars (e.g. "$72,000"). '
          '"percentage" → percent with up to one decimal (e.g. "10.1%"). '
          '"integer" → plain integer (e.g. "42"). '
          'Omit to hide the value label.',
      enumValues: ['usd', 'percentage', 'integer'],
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

/// Resolves where the raw numeric slider value is stored in the data model.
String _sliderValueStoragePath(String componentId, Object valueRef) {
  if (valueRef is Map && valueRef.containsKey('path')) {
    return valueRef['path'] as String;
  }
  return '/$componentId/value';
}

/// What to pass to [BoundNumber.value]: bindings/calls as-is, else path map.
Object _boundNumberSpec(Object valueRef, String storagePath) {
  if (valueRef is Map &&
      (valueRef.containsKey('path') || valueRef.containsKey('call'))) {
    return valueRef;
  }
  return {'path': storagePath};
}

SliderFormatter? _parseFormatter(String? raw) {
  return switch (raw) {
    'usd' => SliderFormatter.usd,
    'percentage' => SliderFormatter.percentage,
    'integer' => SliderFormatter.integer,
    _ => null,
  };
}

/// CatalogItem that renders a [GCNSlider] with the value bound to
/// [DataContext].
///
/// The thumb position reads from [BoundNumber] (literal, path, or function).
/// User drags call [DataContext.update] for the numeric value path only;
/// the top-right value label is computed from the current value and
/// [SliderFormatter] (not stored on the data model).
///
/// `title` and `subtitle` support string model bindings.
final gcnSliderItem = CatalogItem(
  name: 'GCNSlider',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final valueRef = json['value']!;
    final valueStoragePath = _sliderValueStoragePath(ctx.id, valueRef);
    final min = (json['min']! as num).toDouble();
    final max = (json['max']! as num).toDouble();
    final divisions = (json['divisions'] as num?)?.toInt();
    final rawSplitLabels = json['splitLabels'] as List?;
    final formatter = _parseFormatter(json['formatter'] as String?);

    return _BoundGCNSlider(
      titleValue: json['title']!,
      subtitleValue: json['subtitle']!,
      boundNumberValue: _boundNumberSpec(valueRef, valueStoragePath),
      valueRef: valueRef,
      valueStoragePath: valueStoragePath,
      min: min,
      max: max,
      formatter: formatter,
      minLabel: json['minLabel'] as String?,
      maxLabel: json['maxLabel'] as String?,
      divisions: divisions,
      splitLabels: rawSplitLabels?.cast<String>(),
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _BoundGCNSlider extends StatefulWidget {
  const _BoundGCNSlider({
    required this.titleValue,
    required this.subtitleValue,
    required this.boundNumberValue,
    required this.valueRef,
    required this.valueStoragePath,
    required this.min,
    required this.max,
    required this.dataContext,
    required this.componentId,
    this.formatter,
    this.minLabel,
    this.maxLabel,
    this.divisions,
    this.splitLabels,
  });

  final Object titleValue;
  final Object subtitleValue;
  final Object boundNumberValue;
  final Object valueRef;
  final String valueStoragePath;
  final double min;
  final double max;
  final SliderFormatter? formatter;
  final String? minLabel;
  final String? maxLabel;
  final int? divisions;
  final List<String>? splitLabels;
  final DataContext dataContext;
  final String componentId;

  @override
  State<_BoundGCNSlider> createState() => _BoundGCNSliderState();
}

class _BoundGCNSliderState extends State<_BoundGCNSlider> {
  @override
  void initState() {
    super.initState();
    _seedIfNeeded();
  }

  void _seedIfNeeded() {
    final valueRef = widget.valueRef;
    if (valueRef is! num) return;
    final path = DataPath(widget.valueStoragePath);
    if (widget.dataContext.getValue<Object?>(path) != null) return;
    final v = valueRef.toDouble().clamp(widget.min, widget.max);
    widget.dataContext.update(path, v);
  }

  void _writeValuesToModel(double newValue) {
    widget.dataContext.update(DataPath(widget.valueStoragePath), newValue);
  }

  String _formatDisplayValue(BuildContext context, double value) {
    final formatter = widget.formatter!;
    final locale = Localizations.maybeLocaleOf(context)?.toString();
    return switch (formatter) {
      SliderFormatter.usd => NumberFormat.simpleCurrency(
        locale: locale,
        decimalDigits: 0,
      ).format(value.round()),
      SliderFormatter.percentage =>
        value == value.roundToDouble()
            ? '${value.round()}%'
            : '${value.toStringAsFixed(1)}%',
      SliderFormatter.integer => NumberFormat.decimalPattern(
        locale,
      ).format(value.round()),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BoundNumber(
      dataContext: widget.dataContext,
      value: widget.boundNumberValue,
      builder: (context, boundValue) {
        final effective =
            boundValue ??
            (widget.valueRef is num ? widget.valueRef as num : null);
        final thumb = (effective?.toDouble() ?? widget.min).clamp(
          widget.min,
          widget.max,
        );
        return BoundString(
          dataContext: widget.dataContext,
          value: widget.titleValue,
          builder: (context, title) {
            return BoundString(
              dataContext: widget.dataContext,
              value: widget.subtitleValue,
              builder: (context, subtitle) {
                return GCNSlider(
                  title: title ?? '',
                  subtitle: subtitle ?? '',
                  value: thumb,
                  min: widget.min,
                  max: widget.max,
                  valueLabel: widget.formatter != null
                      ? _formatDisplayValue(context, thumb)
                      : null,
                  minLabel: widget.minLabel,
                  maxLabel: widget.maxLabel,
                  divisions: widget.divisions,
                  splitLabels: widget.splitLabels,
                  onChanged: _writeValuesToModel,
                );
              },
            );
          },
        );
      },
    );
  }
}
