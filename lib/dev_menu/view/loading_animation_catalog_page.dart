import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';

/// {@template loading_animation_catalog_page}
/// Catalog page for previewing the loading Rive animation.
///
/// Shows the overlay animation that plays while the app transitions
/// from the focus screen to the chat screen.
/// {@endtemplate}
class LoadingAnimationCatalogPage extends StatelessWidget {
  /// {@macro loading_animation_catalog_page}
  const LoadingAnimationCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Animation')),
      body: const LoadingOverlay(),
    );
  }
}
