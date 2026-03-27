import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';
import 'package:rive/rive.dart';

/// {@template thinking_animation}
/// A reusable widget that plays the AI thinking Rive animation.
///
/// Used as a loading indicator within the simulator dashboard while
/// the AI is generating content.
///
/// Set [width] to control the size. The height is derived from the
/// Rive artboard's aspect ratio.
/// {@endtemplate}
class ThinkingAnimation extends StatefulWidget {
  /// {@macro thinking_animation}
  const ThinkingAnimation({
    this.width = 200,
    this.height,
    this.alignment = Alignment.center,
    super.key,
  });

  /// The width of the animation. Ignored when [height] is set (width is
  /// derived from the artboard's aspect ratio instead).
  final double width;

  /// Optional fixed height. When set, the width is derived from the
  /// artboard's aspect ratio, keeping the animation contained.
  final double? height;

  /// The alignment of the animation.
  final Alignment alignment;

  @override
  State<ThinkingAnimation> createState() => _ThinkingAnimationState();
}

class _ThinkingAnimationState extends State<ThinkingAnimation> {
  FileLoader? _fileLoader;

  @override
  void initState() {
    super.initState();
    try {
      _fileLoader = FileLoader.fromAsset(
        Assets.animations.thinking,
        riveFactory: Factory.flutter,
      );
    } on Object {
      // Rive native library not available (e.g., in tests).
    }
  }

  @override
  void dispose() {
    _fileLoader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileLoader = _fileLoader;
    if (fileLoader == null) {
      return SizedBox(
        width: widget.height != null ? null : widget.width,
        height: widget.height,
      );
    }

    return SizedBox(
      width: widget.height != null ? null : widget.width,
      height: widget.height,
      child: RiveWidgetBuilder(
        fileLoader: fileLoader,
        builder: (context, state) => switch (state) {
          RiveLoaded(:final controller) => AspectRatio(
            aspectRatio:
                controller.artboard.bounds.width /
                controller.artboard.bounds.height,
            child: RiveWidget(
              controller: controller,
              alignment: widget.alignment,
            ),
          ),
          RiveLoading() => const SizedBox.shrink(),
          RiveFailed() => const SizedBox.shrink(),
        },
      ),
    );
  }
}
