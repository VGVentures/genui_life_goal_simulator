import 'package:finance_app/app/presentation.dart';
import 'package:flutter/widgets.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'text': A2uiSchemas.stringReference(
      description: 'The label displayed on the AI button.',
    ),
  },
  required: ['text'],
);

/// CatalogItem that renders an [AiButton].
///
/// Disables itself after the first tap to prevent duplicate requests.
final aiButtonItem = CatalogItem(
  name: 'AiButton',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;

    return _OneTapAiButton(
      textValue: json['text'],
      dataContext: ctx.dataContext,
      dispatchEvent: ctx.dispatchEvent,
      componentId: ctx.id,
    );
  },
);

class _OneTapAiButton extends StatefulWidget {
  const _OneTapAiButton({
    required this.textValue,
    required this.dataContext,
    required this.dispatchEvent,
    required this.componentId,
  });

  final Object? textValue;
  final DataContext dataContext;
  final DispatchEventCallback dispatchEvent;
  final String componentId;

  @override
  State<_OneTapAiButton> createState() => _OneTapAiButtonState();
}

class _OneTapAiButtonState extends State<_OneTapAiButton> {
  bool _tapped = false;

  void _onTap() {
    if (_tapped) return;
    setState(() => _tapped = true);

    widget.dispatchEvent(
      UserActionEvent(
        name: 'ai_button_tapped',
        sourceComponentId: widget.componentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BoundString(
      dataContext: widget.dataContext,
      value: widget.textValue,
      builder: (context, text) {
        return IgnorePointer(
          ignoring: _tapped,
          child: Opacity(
            opacity: _tapped ? 0.5 : 1.0,
            child: AiButton(
              text: text ?? '',
              onTap: _onTap,
            ),
          ),
        );
      },
    );
  }
}
