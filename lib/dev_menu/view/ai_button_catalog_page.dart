import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';

/// {@template ai_button_catalog_page}
/// Catalog page showcasing all [AiButton] variants.
/// {@endtemplate}
class AiButtonCatalogPage extends StatelessWidget {
  /// {@macro ai_button_catalog_page}
  const AiButtonCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('AiButton')),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.md),
        children: [
          const SizedBox(height: Spacing.xs),
          AiButton(
            text: "What's eating my money?",
            onTap: () {},
          ),
          const SizedBox(height: Spacing.md),
          AiButton(
            text: 'Suggest a budget',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
