import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genui_life_goal_simulator/gen/assets.gen.dart';
import 'package:rive/rive.dart';

/// {@template loading_overlay}
/// A full-screen overlay that plays the large Rive loading animation.
///
/// Used for major transitions like navigating to the summary dashboard.
/// Falls back to a plain background if the Rive native library is unavailable.
/// {@endtemplate}
class LoadingOverlay extends StatefulWidget {
  /// {@macro loading_overlay}
  const LoadingOverlay({
    this.onAnimationComplete,
    this.backgroundColor = Colors.black,
    this.backgroundOpacity = 0.5,
    this.animationDuration = const Duration(seconds: 3),
    super.key,
  });

  /// Called when the animation completes or the fallback timer fires.
  final VoidCallback? onAnimationComplete;

  final Color backgroundColor;
  final double backgroundOpacity;

  /// How long the overlay stays visible before calling [onAnimationComplete].
  /// Acts as a fallback if the Rive animation doesn't fire a completion event.
  final Duration animationDuration;

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  FileLoader? _fileLoader;
  Timer? _completionTimer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    // Always start a fallback timer so the overlay eventually completes
    // even if the Rive animation fails to load.
    _completionTimer = Timer(widget.animationDuration, _complete);

    try {
      _fileLoader = FileLoader.fromAsset(
        Assets.animations.loading,
        riveFactory: Factory.flutter,
      );
    } on Object {
      // Rive native library not available — fallback timer will handle it.
    }
  }

  void _complete() {
    if (_completed || !mounted) return;
    _completed = true;
    widget.onAnimationComplete?.call();
  }

  void _onLoaded(RiveLoaded state) {
    state.controller.stateMachine.addEventListener(_onRiveEvent);
  }

  void _onRiveEvent(Event event) {
    if (event case GeneralEvent(name: 'complete' || 'exit' || 'done')) {
      _completionTimer?.cancel();
      _complete();
    }
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    _fileLoader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileLoader = _fileLoader;

    return ColoredBox(
      color: widget.backgroundColor.withValues(
        alpha: widget.backgroundOpacity,
      ),
      child: Center(
        child: fileLoader == null
            ? const SizedBox.shrink()
            : RiveWidgetBuilder(
                fileLoader: fileLoader,
                onLoaded: _onLoaded,
                builder: (context, state) => switch (state) {
                  RiveLoaded(:final controller) => SizedBox(
                    width: 500,
                    child: RiveWidget(
                      controller: controller,
                    ),
                  ),
                  RiveLoading() => const SizedBox.shrink(),
                  RiveFailed() => const SizedBox.shrink(),
                },
              ),
      ),
    );
  }
}
