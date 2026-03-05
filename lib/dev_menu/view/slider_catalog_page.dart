import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template slider_catalog_page}
/// Catalog page showcasing all [GcnSlider] variants.
/// {@endtemplate}
class SliderCatalogPage extends StatefulWidget {
  /// {@macro slider_catalog_page}
  const SliderCatalogPage({super.key});

  @override
  State<SliderCatalogPage> createState() => _SliderCatalogPageState();
}

class _SliderCatalogPageState extends State<SliderCatalogPage> {
  double _basicValue = 450;
  double _splitsValue = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Slider')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          GcnSlider(
            title: 'Slider Title',
            subtitle: 'Dining • Feb 18',
            value: _basicValue,
            min: 1,
            max: 1270,
            valueLabel: '\$${_basicValue.toStringAsFixed(0)}',
            minLabel: r'$1',
            maxLabel: r'$1270',
            onChanged: (v) => setState(() => _basicValue = v),
          ),
          const SizedBox(height: Spacing.lg),
          GcnSlider(
            title: 'Slider Title',
            subtitle: 'Dining • Feb 18',
            value: _splitsValue,
            min: 1,
            max: 6,
            divisions: 5,
            splitLabels: const ['1', '2', '3', '4', '5', '6'],
            onChanged: (v) => setState(() => _splitsValue = v),
          ),
        ],
      ),
    );
  }
}
