import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/design_system/design_system.dart';
import 'package:genui_life_goal_simulator/simulator/bloc/bloc.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  description:
      'A call-to-action button for navigating to a detail view, '
      'confirming a choice, or starting a workflow.',
  properties: {
    'label': A2uiSchemas.stringReference(
      description: 'The button text.',
    ),
    'variant': S.string(
      description: 'Visual style of the button.',
      enumValues: ['filled', 'outlined'],
    ),
    'size': S.string(
      description: 'Size of the button.',
      enumValues: ['large', 'small'],
    ),
    'action': A2uiSchemas.action(
      description: 'The action to perform when the button is pressed.',
    ),
    'showLoadingOverlay': S.boolean(
      description:
          'Whether to show the full-screen loading animation when this '
          'button is pressed. Use for major transitions like navigating '
          'to the summary dashboard.',
    ),
  },
  required: ['label', 'variant', 'size', 'action'],
);

/// CatalogItem that renders an [AppButton] widget.
///
/// Disables itself after the first tap to prevent duplicate requests.
final appButtonItem = CatalogItem(
  name: 'AppButton',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    final labelValue = json['label']!;
    final variant = switch (json['variant']! as String) {
      'outlined' => AppButtonVariant.outlined,
      _ => AppButtonVariant.filled,
    };
    final size = switch (json['size']! as String) {
      'small' => AppButtonSize.small,
      _ => AppButtonSize.large,
    };
    final action = json['action'] as Map<String, Object?>?;
    final showLoadingOverlay = json['showLoadingOverlay'] as bool? ?? false;

    return _OneTapAppButton(
      labelValue: labelValue,
      variant: variant,
      size: size,
      action: action,
      showLoadingOverlay: showLoadingOverlay,
      dataContext: ctx.dataContext,
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _OneTapAppButton extends StatefulWidget {
  const _OneTapAppButton({
    required this.labelValue,
    required this.variant,
    required this.size,
    required this.action,
    required this.showLoadingOverlay,
    required this.dataContext,
    required this.dispatchEvent,
    required this.componentId,
  });

  final Object labelValue;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Map<String, Object?>? action;
  final bool showLoadingOverlay;
  final DataContext dataContext;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_OneTapAppButton> createState() => _OneTapAppButtonState();
}

class _OneTapAppButtonState extends State<_OneTapAppButton> {
  bool _tapped = false;

  void _onPressed() {
    if (_tapped) return;
    setState(() => _tapped = true);

    if (widget.showLoadingOverlay) {
      context.read<SimulatorBloc>().add(
        const SimulatorLoadingOverlayRequested(),
      );
    }

    final action = widget.action;
    if (action case {'event': final Map<String, Object?> event}) {
      final dataModel = widget.dataContext.dataModel
          .getValue<Map<String, Object?>>(DataPath.root);

      widget.dispatchEvent(
        UserActionEvent(
          name: event['name']! as String,
          sourceComponentId: widget.componentId,
          context: {
            ...event['context'] as Map<String, Object?>? ?? {},
            if (dataModel != null) ...dataModel,
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SimulatorBloc>().state;
    final showThinking =
        _tapped && state.isLoading && !widget.showLoadingOverlay;

    return BoundString(
      dataContext: widget.dataContext,
      value: widget.labelValue,
      builder: (context, label) {
        final button = AppButton(
          label: label ?? '',
          variant: widget.variant,
          size: widget.size,
          onPressed: _tapped || state.isLoading ? null : _onPressed,
        );

        return Padding(
          padding: const EdgeInsets.only(top: Spacing.md),
          child: showThinking
              ? Stack(
                  children: [
                    Visibility(
                      visible: false,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: button,
                    ),
                    ThinkingAnimation(height: widget.size.height),
                  ],
                )
              : button,
        );
      },
    );
  }
}
