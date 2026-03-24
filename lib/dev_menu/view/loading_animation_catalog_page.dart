import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';
import 'package:rive/rive.dart';

/// {@template loading_animation_catalog_page}
/// Catalog page for previewing the loading Rive animation.
///
/// Shows the overlay animation that plays while the app transitions
/// from the focus screen to the chat screen.
/// {@endtemplate}
class LoadingAnimationCatalogPage extends StatefulWidget {
  /// {@macro loading_animation_catalog_page}
  const LoadingAnimationCatalogPage({super.key});

  @override
  State<LoadingAnimationCatalogPage> createState() =>
      _LoadingAnimationCatalogPageState();
}

class _LoadingAnimationCatalogPageState
    extends State<LoadingAnimationCatalogPage> {
  late final FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      Assets.animations.loading,
      riveFactory: Factory.flutter,
    );
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Animation')),
      body: ColoredBox(
        color: Colors.black,
        child: Center(
          child: RiveWidgetBuilder(
            fileLoader: _fileLoader,
            builder: (context, state) => switch (state) {
              RiveLoaded(:final controller) => RiveWidget(
                controller: controller,
              ),
              RiveLoading() => const CircularProgressIndicator(),
              RiveFailed() => const Text(
                'Failed to load animation',
                style: TextStyle(color: Colors.white),
              ),
            },
          ),
        ),
      ),
    );
  }
}
