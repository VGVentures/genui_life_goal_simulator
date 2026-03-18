import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:vgv_genui_financial_advisor/gen/assets.gen.dart';

/// {@template thinking_animation_catalog_page}
/// Catalog page for previewing the AI thinking Rive animation.
///
/// Shows the animation that plays between chat messages while the AI
/// is generating a response.
/// {@endtemplate}
class ThinkingAnimationCatalogPage extends StatefulWidget {
  /// {@macro thinking_animation_catalog_page}
  const ThinkingAnimationCatalogPage({super.key});

  @override
  State<ThinkingAnimationCatalogPage> createState() =>
      _ThinkingAnimationCatalogPageState();
}

class _ThinkingAnimationCatalogPageState
    extends State<ThinkingAnimationCatalogPage> {
  late final FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      Assets.animations.thinking,
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
      appBar: AppBar(title: const Text('Thinking Animation')),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: RiveWidgetBuilder(
            fileLoader: _fileLoader,
            builder: (context, state) => switch (state) {
              RiveLoaded(:final controller) => RiveWidget(
                controller: controller,
              ),
              RiveLoading() => const CircularProgressIndicator(),
              RiveFailed() => const Text('Failed to load animation'),
            },
          ),
        ),
      ),
    );
  }
}
