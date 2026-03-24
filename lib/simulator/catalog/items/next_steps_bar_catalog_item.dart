import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
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
/// Uses an [Overlay] to render fixed at the bottom of the screen.
/// The bar shrinks with the screen and the buttons scroll horizontally
/// if they don't fit.
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
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>();
        return Positioned(
          left: Spacing.md,
          right: Spacing.md,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: Center(
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: Spacing.md,
                      children: widget.suggestions.map((s) {
                        final label = s['label']! as String;
                        return IgnorePointer(
                          ignoring: _tapped,
                          child: Opacity(
                            opacity: _tapped ? 0.5 : 1.0,
                            child: AiButton(
                              text: label,
                              onTap: () => _onTap(label),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
    return const SizedBox.shrink();
  }
}
