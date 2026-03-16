import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({
    required this.animationPath,
    required this.onAnimationComplete,
    this.backgroundColor = Colors.black,
    this.backgroundOpacity = 0.5,
    this.animationDuration = const Duration(seconds: 3),
    super.key,
  });

  final String animationPath;
  final VoidCallback onAnimationComplete;
  final Color backgroundColor;
  final double backgroundOpacity;

  /// How long the overlay stays visible before navigating.
  /// Adjust this to match the duration of your Rive animation.
  final Duration animationDuration;

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  late final FileLoader _fileLoader;
  Timer? _completionTimer;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      widget.animationPath,
      riveFactory: Factory.flutter,
    );
  }

  void _onLoaded(RiveLoaded state) {
    _completionTimer = Timer(widget.animationDuration, () {
      if (mounted) widget.onAnimationComplete();
    });

    state.controller.stateMachine.addEventListener(_onRiveEvent);
  }

  void _onRiveEvent(Event event) {
    if (event case GeneralEvent(name: 'complete' || 'exit' || 'done')) {
      _completionTimer?.cancel();
      if (mounted) widget.onAnimationComplete();
    }
  }

  @override
  void dispose() {
    _completionTimer?.cancel();
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backgroundColor.withValues(
        alpha: widget.backgroundOpacity,
      ),
      child: Center(
        child: RiveWidgetBuilder(
          fileLoader: _fileLoader,
          onLoaded: _onLoaded,
          builder: (context, state) => switch (state) {
            RiveLoaded(:final controller) => RiveWidget(
              controller: controller,
            ),
            RiveLoading() => const SizedBox.shrink(),
            RiveFailed() => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
