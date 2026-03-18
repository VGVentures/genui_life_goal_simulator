import 'package:flutter/material.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

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
      body: Center(
        child: AiButton(
          text: "What's eating my money?",
          onTap: () {},
        ),
      ),
    );
  }
}
