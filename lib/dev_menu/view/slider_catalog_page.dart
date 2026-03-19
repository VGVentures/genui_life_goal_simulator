import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

const _splitLabels = ['1', '2', '3', '4', '5', '6'];

/// {@template slider_catalog_page}
/// Catalog page showcasing all [GCNSlider] variants.
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
    final colors = Theme.of(context).extension<AppColors>();

    return Scaffold(
      backgroundColor: colors?.onPrimary,
      appBar: AppBar(title: const Text('Slider')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          GCNSlider(
            title: 'Slider Title',
            subtitle: 'Dining • Feb 18',
            value: _basicValue,
            min: 1,
            max: 1270,
            valueLabel: '\$${_basicValue.toStringAsFixed(0)}',
            minLabel: r'$1',
            maxLabel: r'$1270',
            onChanged: (value) => setState(() => _basicValue = value),
          ),
          const SizedBox(height: Spacing.lg),
          GCNSlider(
            title: 'Slider Title',
            subtitle: 'Dining • Feb 18',
            value: _splitsValue,
            min: 1,
            max: 6,
            divisions: 5,
            splitLabels: _splitLabels,
            onChanged: (value) => setState(() => _splitsValue = value),
          ),
        ],
      ),
    );
  }
}
