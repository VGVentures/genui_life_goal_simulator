import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template line_chart_catalog_page}
/// Catalog page showcasing [LineChart] default and tooltip states.
/// {@endtemplate}
class LineChartCatalogPage extends StatelessWidget {
  /// {@macro line_chart_catalog_page}
  const LineChartCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    const points = [
      LineChartPoint(
        xLabel: 'Sep',
        value: 4200,
        tooltipLabel: 'Sep',
        tooltipValue: r'Spend: $4200',
      ),
      LineChartPoint(
        xLabel: 'Oct',
        value: 3500,
        tooltipLabel: 'Oct',
        tooltipValue: r'Spend: $3500',
      ),
      LineChartPoint(
        xLabel: 'Nov',
        value: 4500,
        tooltipLabel: 'Nov',
        tooltipValue: r'Spend: $4500',
      ),
      LineChartPoint(
        xLabel: 'Dec',
        value: 3800,
        tooltipLabel: 'Dec',
        tooltipValue: r'Spend: $3800',
      ),
      LineChartPoint(
        xLabel: 'Jan',
        value: 4700,
        tooltipLabel: 'Jan',
        tooltipValue: r'Spend: $4700',
      ),
      LineChartPoint(
        xLabel: 'Feb',
        value: 5000,
        tooltipLabel: 'Feb',
        tooltipValue: r'Spend: $5000',
      ),
    ];

    const yLabels = [r'$0.0k', r'$1.5k', r'$3.0k', r'$4.5k', r'$6.0k'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('LineChart')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: const [
          SizedBox(height: Spacing.xs),
          SizedBox(
            height: 240,
            child: LineChart(
              points: points,
              yAxisLabels: yLabels,
              minValue: 0,
              maxValue: 6000,
            ),
          ),
        ],
      ),
    );
  }
}
