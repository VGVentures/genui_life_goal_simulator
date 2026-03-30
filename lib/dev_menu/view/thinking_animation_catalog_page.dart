import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template thinking_animation_catalog_page}
/// Catalog page for previewing the AI thinking Rive animation.
///
/// Shows the animation that plays between chat messages while the AI
/// is generating a response.
/// {@endtemplate}
class ThinkingAnimationCatalogPage extends StatelessWidget {
  /// {@macro thinking_animation_catalog_page}
  const ThinkingAnimationCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thinking Animation')),
      body: const Center(child: ThinkingAnimation()),
    );
  }
}
