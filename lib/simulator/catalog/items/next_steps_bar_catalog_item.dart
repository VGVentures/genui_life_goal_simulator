import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/bloc.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A row of 2–3 AiButton suggestions fixed to the bottom of the '
      'summary screen. Each button represents a next step the user can '
      'take to continue their financial planning journey. '
      'ALWAYS include this as the LAST component on summary screens.',
  properties: {
    'suggestions': S.list(
      description: 'List of 2–3 next-step suggestions.',
      items: S.object(
        properties: {
          'label': S.string(
            description:
                'Short button label (e.g. "6-month trend", '
                '"Find savings opportunities").',
          ),
        },
        required: ['label'],
      ),
      minItems: 2,
    ),
  },
  required: ['suggestions'],
);

/// A bottom bar with 2–3 AiButton suggestions for next steps.
///
/// Uses an [Overlay] to render fixed at the bottom of the viewport,
/// independent of scroll position. The overlay is removed when the
/// widget is disposed (i.e., when the page navigates away).
///
/// When the LLM is loading, the buttons are replaced with a
/// [ThinkingAnimation] and the container animates to fit.
final nextStepsBarItem = CatalogItem(
  name: 'NextStepsBar',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawSuggestions = json['suggestions']! as List<Object?>;

    return _NextStepsBarOverlay(
      suggestions: rawSuggestions.cast<Map<String, Object?>>(),
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _NextStepsBarOverlay extends StatefulWidget {
  const _NextStepsBarOverlay({
    required this.suggestions,
    required this.dispatchEvent,
    required this.componentId,
  });

  final List<Map<String, Object?>> suggestions;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_NextStepsBarOverlay> createState() => _NextStepsBarOverlayState();
}

class _NextStepsBarOverlayState extends State<_NextStepsBarOverlay> {
  OverlayEntry? _overlayEntry;
  bool _tapped = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showOverlay();
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    super.dispose();
  }

  void _onTap(String label) {
    if (_tapped) return;
    _tapped = true;
    _overlayEntry?.markNeedsBuild();
    widget.dispatchEvent(
      UserActionEvent(
        name: 'next_step_selected',
        sourceComponentId: widget.componentId,
        context: {'label': label},
      ),
    );
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (_) {
        final colors = Theme.of(context).extension<AppColors>();
        final showThinking = _tapped;
        final isDisabledByLoading = !_tapped && _isLoading;

        Widget buttons = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Spacing.md,
            children: widget.suggestions.map((s) {
              final label = s['label']! as String;
              return AiButton(
                text: label,
                onTap: () => _onTap(label),
              );
            }).toList(),
          ),
        );

        if (isDisabledByLoading) {
          buttons = IgnorePointer(
            child: Opacity(
              opacity: 0.5,
              child: buttons,
            ),
          );
        }

        return Positioned(
          left: Spacing.md,
          right: Spacing.md,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: Center(
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.sm,
                      horizontal: Spacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: colors?.surfaceVariant ?? Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4D6D92F5),
                          blurRadius: 40,
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    child: showThinking
                        ? const ThinkingAnimation(width: 150)
                        : buttons,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SimulatorBloc, SimulatorState>(
      listenWhen: (previous, current) =>
          previous.isLoading != current.isLoading,
      listener: (context, state) {
        _isLoading = state.isLoading;
        _overlayEntry?.markNeedsBuild();
      },
      child: const SizedBox.shrink(),
    );
  }
}
