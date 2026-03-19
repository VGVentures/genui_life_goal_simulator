import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:vgv_genui_financial_advisor/advisor/bloc/bloc.dart';
import 'package:vgv_genui_financial_advisor/design_system/design_system.dart';

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
    'isLoading': S.boolean(
      description: 'Whether the button shows a loading indicator.',
    ),
    'action': A2uiSchemas.action(
      description: 'The action to perform when the button is pressed.',
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
    final isLoading = json['isLoading'] as bool? ?? false;
    final action = json['action'] as Map<String, Object?>?;

    return _OneTapAppButton(
      labelValue: labelValue,
      variant: variant,
      size: size,
      isLoading: isLoading,
      action: action,
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
    required this.isLoading,
    required this.action,
    required this.dataContext,
    required this.dispatchEvent,
    required this.componentId,
  });

  final Object labelValue;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final Map<String, Object?>? action;
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
    final blocLoading = context.select<AdvisorBloc, bool>(
      (bloc) => bloc.state.isLoading,
    );

    return BoundString(
      dataContext: widget.dataContext,
      value: widget.labelValue,
      builder: (context, label) {
        return AppButton(
          label: label ?? '',
          variant: widget.variant,
          size: widget.size,
          isLoading: widget.isLoading || (_tapped && blocLoading),
          onPressed: _tapped ? null : _onPressed,
        );
      },
    );
  }
}
