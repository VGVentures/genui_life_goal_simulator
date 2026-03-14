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
/// On desktop, uses an [Overlay] to render fixed at the bottom.
/// On mobile, renders inline in the scrollable content.
final nextStepsBarItem = CatalogItem(
  name: 'NextStepsBar',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final rawSuggestions = json['suggestions']! as List<Object?>;

    return _NextStepsBar(
      suggestions: rawSuggestions.cast<Map<String, Object?>>(),
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _NextStepsBar extends StatefulWidget {
  const _NextStepsBar({
    required this.suggestions,
    required this.dispatchEvent,
    required this.componentId,
  });

  final List<Map<String, Object?>> suggestions;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_NextStepsBar> createState() => _NextStepsBarState();
}

class _NextStepsBarState extends State<_NextStepsBar> {
  OverlayEntry? _overlayEntry;
  bool _tapped = false;
  bool _isDesktop = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDesktop = Breakpoints.isDesktop(
      MediaQuery.sizeOf(context).width,
    );

    if (isDesktop != _isDesktop) {
      _isDesktop = isDesktop;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_isDesktop) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      });
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void _onTap(String label) {
    if (_tapped) return;
    setState(() => _tapped = true);
    _overlayEntry?.markNeedsBuild();
    widget.dispatchEvent(
      UserActionEvent(
        name: 'next_step_selected',
        sourceComponentId: widget.componentId,
        context: {'label': label},
      ),
    );
  }

  List<Widget> _buildButtons() {
    return widget.suggestions.map((s) {
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
    }).toList();
  }

  void _showOverlay() {
    _removeOverlay();
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: Spacing.md,
                    children: _buildButtons(),
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
    // Desktop: invisible placeholder, real UI is in the overlay.
    if (_isDesktop) return const SizedBox.shrink();

    // Mobile: render inline as a wrapped column of buttons.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: Spacing.sm,
        runSpacing: Spacing.sm,
        children: _buildButtons(),
      ),
    );
  }
}
