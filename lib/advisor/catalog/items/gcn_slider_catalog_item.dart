import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A slider control for adjusting a numeric value within a range, '
      'such as a budget limit or spending target.',
  properties: {
    'title': S.string(description: 'Header title displayed above the slider.'),
    'subtitle': S.string(
      description: 'Subtitle shown below the title (e.g. "Dining • Feb 18").',
    ),
    'value': S.number(
      description: 'Current slider value. Must be between min and max.',
    ),
    'min': S.number(description: 'Minimum slider value.'),
    'max': S.number(description: 'Maximum slider value.'),
    'valueLabel': S.string(
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

/// CatalogItem that renders a [GCNSlider] widget.
final gcnSliderItem = CatalogItem(
  name: 'GCNSlider',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final value = (json['value']! as num).toDouble();
    final min = (json['min']! as num).toDouble();
    final max = (json['max']! as num).toDouble();
    final divisions = (json['divisions'] as num?)?.toInt();
    final rawSplitLabels = json['splitLabels'] as List?;

    return GCNSlider(
      title: json['title']! as String,
      subtitle: json['subtitle']! as String,
      value: value,
      min: min,
      max: max,
      valueLabel: json['valueLabel'] as String?,
      minLabel: json['minLabel'] as String?,
      maxLabel: json['maxLabel'] as String?,
      divisions: divisions,
      splitLabels: rawSplitLabels?.cast<String>(),
      onChanged: (_) {},
    );
  },
);
