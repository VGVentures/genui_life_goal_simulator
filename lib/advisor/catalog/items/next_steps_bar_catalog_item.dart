import 'package:finance_app/app/presentation.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
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
/// Uses an [Overlay] to render itself fixed at the bottom of the screen,
/// independent of any scroll view.
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay();
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    super.dispose();
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final colors = Theme.of(context).extension<AppColors>();
        return Positioned(
          left: 0,
          right: 0,
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
                    color: colors?.surfaceVariant ??
                        Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x4D6D92F5),
                        blurRadius: 40,
                        offset: Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Spacing.md,
                children: widget.suggestions.map((s) {
                  final label = s['label']! as String;
                  return AiButton(
                    text: label,
                    onTap: () {
                      widget.dispatchEvent(
                        UserActionEvent(
                          name: 'next_step_selected',
                          sourceComponentId: widget.componentId,
                          context: {'label': label},
                        ),
                      );
                    },
                  );
                }).toList(),
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
    // Invisible placeholder — the real UI is in the overlay.
    return const SizedBox.shrink();
  }
}
