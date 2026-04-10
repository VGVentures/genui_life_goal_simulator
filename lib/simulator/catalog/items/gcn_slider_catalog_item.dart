import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:intl/intl.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A slider control for adjusting a numeric value within a range, '
      'such as a budget limit or spending target. '
      'The current value is stored in the data model at default path '
      '"/<componentId>/value" (raw number). Locale-aware display with '
      'optional prefix (e.g. "${r'$72,000'}") is done in the widget only; '
      'bind other components to "/<componentId>/value" if you need the raw '
      'number reflected as text. '
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
    'prefix': S.string(
      description:
          r'Optional prefix for the in-widget value label (e.g. "$", "€").',
    ),
    'valueLabel': A2uiSchemas.stringReference(
      description:
          'Optional. When set (any literal or {"path": "..."}), the top-right '
          'amount row is enabled and stays in sync via bindings. The text '
          'shown is always computed from the current slider value, prefix, '
          'and locale (the bound value is not drawn as-is). For basic '
          'sliders, a non-empty prefix alone also enables this row.',
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

String _formatSliderDisplayValue(
  BuildContext context,
  double value,
  String prefix,
) {
  final locale = Localizations.maybeLocaleOf(context)?.toString();
  final number = NumberFormat.decimalPattern(locale).format(value.round());
  return '$prefix$number';
}

/// Seeds the value path when the LLM sent a literal and the model is empty.
void _seedSliderModelIfNeeded({
  required CatalogItemContext ctx,
  required Object valueRef,
  required String valueStoragePath,
  required double min,
  required double max,
}) {
  if (valueRef is! num) return;
  final path = DataPath(valueStoragePath);
  if (ctx.dataContext.getValue<Object?>(path) != null) return;
  final v = valueRef.toDouble().clamp(min, max);
  ctx.dataContext.update(path, v);
}

/// CatalogItem that renders a [GCNSlider] with the value bound to
/// [DataContext].
///
/// The thumb position reads from [BoundNumber] (literal, path, or function).
/// User drags call [DataContext.update] for the numeric value path only;
/// formatted currency and the top-right value label are computed in the
/// widget (not stored on the data model).
///
/// `title`, `subtitle`, and `valueLabel` support string model bindings.
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
    final prefix = json['prefix'] as String? ?? '';

    _seedSliderModelIfNeeded(
      ctx: ctx,
      valueRef: valueRef,
      valueStoragePath: valueStoragePath,
      min: min,
      max: max,
    );

    return _BoundGCNSlider(
      titleValue: json['title']!,
      subtitleValue: json['subtitle']!,
      valueLabelValue: json['valueLabel'],
      boundNumberValue: _boundNumberSpec(valueRef, valueStoragePath),
      valueRef: valueRef,
      valueStoragePath: valueStoragePath,
      min: min,
      max: max,
      prefix: prefix,
      minLabel: json['minLabel'] as String?,
      maxLabel: json['maxLabel'] as String?,
      divisions: divisions,
      splitLabels: rawSplitLabels?.cast<String>(),
      dataContext: ctx.dataContext,
      componentId: ctx.id,
    );
  },
);

class _BoundGCNSlider extends StatelessWidget {
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
  final Object boundNumberValue;
  final Object valueRef;
  final String valueStoragePath;
  final double min;
  final double max;
  final String prefix;
  final String? minLabel;
  final String? maxLabel;
  final int? divisions;
  final List<String>? splitLabels;
  final DataContext dataContext;
  final String componentId;

  void _writeValuesToModel(double newValue) {
    dataContext.update(DataPath(valueStoragePath), newValue);
  }

  /// Top-right amount: basic slider shows when [prefix] is non-empty or
  /// [valueLabelValue] is provided; splits variant only when [valueLabelValue]
  /// is set (opt-in).
  bool get _showTopRightAmount => divisions == null
      ? (valueLabelValue != null || prefix.isNotEmpty)
      : valueLabelValue != null;

  Widget _slider(
    BuildContext context, {
    required double thumb,
    required String? title,
    required String? subtitle,
  }) {
    return GCNSlider(
      title: title ?? '',
      subtitle: subtitle ?? '',
      value: thumb,
      min: min,
      max: max,
      valueLabel: _showTopRightAmount
          ? _formatSliderDisplayValue(context, thumb, prefix)
          : null,
      minLabel: minLabel,
      maxLabel: maxLabel,
      divisions: divisions,
      splitLabels: splitLabels,
      onChanged: _writeValuesToModel,
    );
  }

  Widget _boundTitleSubtitle(
    BuildContext context,
    double thumb, {
    Object? valueLabelForBinding,
  }) {
    Widget withTitleSubtitle(String? title, String? subtitle) {
      return _slider(context, thumb: thumb, title: title, subtitle: subtitle);
    }

    if (valueLabelForBinding != null) {
      return BoundString(
        dataContext: dataContext,
        value: valueLabelForBinding,
        builder: (context, _) {
          return BoundString(
            dataContext: dataContext,
            value: titleValue,
            builder: (context, title) {
              return BoundString(
                dataContext: dataContext,
                value: subtitleValue,
                builder: (context, subtitle) {
                  return withTitleSubtitle(title, subtitle);
                },
              );
            },
          );
        },
      );
    }

    return BoundString(
      dataContext: dataContext,
      value: titleValue,
      builder: (context, title) {
        return BoundString(
          dataContext: dataContext,
          value: subtitleValue,
          builder: (context, subtitle) {
            return withTitleSubtitle(title, subtitle);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // BoundNumber must wrap BoundStrings so every value change re-reads bound
    // strings (e.g. title/subtitle/valueLabel paths).
    return BoundNumber(
      dataContext: dataContext,
      value: boundNumberValue,
      builder: (context, boundValue) {
        final effective =
            boundValue ?? (valueRef is num ? valueRef as num : null);
        final thumb = (effective?.toDouble() ?? min).clamp(min, max);
        return _boundTitleSubtitle(
          context,
          thumb,
          valueLabelForBinding: valueLabelValue,
        );
      },
    );
  }
}
