import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A bar chart for comparing values. Set orientation to "vertical" '
      '(bars bottom-to-top) on mobile or "horizontal" (bars left-to-right) '
      'on desktop. Bar values can be literal numbers or data binding paths '
      '(e.g. {"path": "/myValue"}) so the chart updates reactively.',
  properties: {
    'component': S.string(enumValues: ['BarChart']),
    'title': A2uiSchemas.stringReference(
      description: 'An optional chart title.',
    ),
    'orientation': S.string(
      enumValues: ['vertical', 'horizontal'],
      description:
          'The bar orientation. Use "vertical" on mobile and '
          '"horizontal" on desktop.',
    ),
    'bars': S.list(
      description: 'The list of bars to display.',
      items: S.object(
        properties: {
          'label': A2uiSchemas.stringReference(
            description: 'The label for this bar.',
          ),
          'value': A2uiSchemas.numberReference(
            description:
                'The numeric value for this bar. Can be a literal number '
                'or a data binding path (e.g. {"path": "/myValue"}) so the '
                'chart updates when the bound value changes.',
          ),
        },
        required: ['label', 'value'],
      ),
    ),
  },
  required: ['component', 'bars'],
);

extension type _ChartData.fromMap(Map<String, Object?> _json) {
  Object? get title => _json['title'];
  String get orientation =>
      (_json['orientation'] as String?) ?? 'vertical';
  List<Object?> get bars => _json['bars'] as List<Object?>;
}

extension type _BarEntry.fromMap(Map<String, Object?> _json) {
  Object get label => _json['label'] as Object;
  Object get value => _json['value'] as Object;
}

final barChart = CatalogItem(
  name: 'BarChart',
  isImplicitlyFlexible: true,
  dataSchema: _schema,
  exampleData: [
    () => '''
      [
        {
          "id": "root",
          "component": "BarChart",
          "title": "Monthly Sales",
          "orientation": "vertical",
          "bars": [
            { "label": "Jan", "value": 30 },
            { "label": "Feb", "value": 45 },
            { "label": "Mar", "value": 28 }
          ]
        }
      ]
    ''',
  ],
  widgetBuilder: (context) {
    final data = _ChartData.fromMap(
      context.data as Map<String, Object?>,
    );

    final entries = data.bars
        .whereType<Map<String, Object?>>()
        .map(_BarEntry.fromMap)
        .toList();

    // Create a ValueNotifier<num?> for each bar value, supporting both
    // literal numbers and data binding paths (e.g. {"path": "/myValue"}).
    final valueNotifiers = <ValueNotifier<num?>>[];
    for (final entry in entries) {
      final valueRef = entry.value;
      if (valueRef is Map && valueRef.containsKey('path')) {
        valueNotifiers.add(
          context.dataContext
              .subscribe<num>(DataPath(valueRef['path'] as String)),
        );
      } else if (valueRef is num) {
        valueNotifiers.add(ValueNotifier(valueRef.toDouble()));
      } else {
        valueNotifiers.add(ValueNotifier(0));
      }
    }

    return _BarChartWidget(
      title: data.title,
      entries: entries,
      valueNotifiers: valueNotifiers,
      dataContext: context.dataContext,
      isHorizontal: data.orientation == 'horizontal',
    );
  },
);

class _BarChartWidget extends StatelessWidget {
  const _BarChartWidget({
    required this.title,
    required this.entries,
    required this.valueNotifiers,
    required this.dataContext,
    required this.isHorizontal,
  });

  final Object? title;
  final List<_BarEntry> entries;
  final List<ValueNotifier<num?>> valueNotifiers;
  final DataContext dataContext;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final labelAxis = fl.AxisTitles(
      sideTitles: fl.SideTitles(
        showTitles: true,
        reservedSize: isHorizontal ? 80 : 32,
        getTitlesWidget: (double value, fl.TitleMeta meta) {
          final int index = value.toInt();
          if (index < 0 || index >= entries.length) {
            return const SizedBox.shrink();
          }
          return _BarLabel(
            entry: entries[index],
            dataContext: dataContext,
          );
        },
      ),
    );

    const valueAxis = fl.AxisTitles(
      sideTitles: fl.SideTitles(
        showTitles: true,
        reservedSize: 40,
      ),
    );

    const hiddenAxis = fl.AxisTitles(
      sideTitles: fl.SideTitles(showTitles: false),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoundString(
              dataContext: dataContext,
              value: title,
              builder: (context, title) {
                if (title == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    title,
                    style:
                        Theme.of(context).textTheme.titleMedium,
                  ),
                );
              },
            ),
            ListenableBuilder(
              listenable: Listenable.merge(valueNotifiers),
              builder: (context, _) {
                final values = [
                  for (final n in valueNotifiers)
                    (n.value ?? 0).toDouble(),
                ];
                final maxValue = values.fold<double>(
                  0,
                  (max, v) => v > max ? v : max,
                );

                return SizedBox(
                  height: isHorizontal
                      ? entries.length * 48.0 + 24
                      : 200,
                  child: fl.BarChart(
                    fl.BarChartData(
                      alignment: fl.BarChartAlignment.spaceAround,
                      maxY: maxValue * 1.2,
                      barTouchData: fl.BarTouchData(
                        touchTooltipData: fl.BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return fl.BarTooltipItem(
                              rod.toY.toStringAsFixed(0),
                              TextStyle(
                                color: colorScheme.onInverseSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      rotationQuarterTurns: isHorizontal ? 1 : 0,
                      titlesData: fl.FlTitlesData(
                        topTitles: hiddenAxis,
                        rightTitles: hiddenAxis,
                        bottomTitles: labelAxis,
                        leftTitles: valueAxis,
                      ),
                      borderData: fl.FlBorderData(show: false),
                      gridData: fl.FlGridData(
                        drawVerticalLine: isHorizontal,
                        drawHorizontalLine: !isHorizontal,
                      ),
                      barGroups: [
                        for (int i = 0; i < entries.length; i++)
                          fl.BarChartGroupData(
                            x: i,
                            barRods: [
                              fl.BarChartRodData(
                                toY: values[i],
                                color: colorScheme.primary,
                                width: isHorizontal ? 24 : 20,
                                borderRadius: isHorizontal
                                    ? const BorderRadius.horizontal(
                                        right: Radius.circular(4),
                                      )
                                    : const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BarLabel extends StatelessWidget {
  const _BarLabel({
    required this.entry,
    required this.dataContext,
  });

  final _BarEntry entry;
  final DataContext dataContext;

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: dataContext,
      value: entry.label,
      builder: (context, label) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          label ?? '',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
