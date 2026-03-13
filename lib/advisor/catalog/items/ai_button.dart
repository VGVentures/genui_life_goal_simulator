import 'package:finance_app/app/presentation.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

final _schema = S.object(
  properties: {
    'text': S.string(
      description: 'The label displayed on the AI button.',
    ),
  },
  required: ['text'],
);

/// CatalogItem that renders an [AiButton].
final aiButtonItem = CatalogItem(
  name: 'AiButton',
  dataSchema: _schema,
  widgetBuilder: (ctx) {
    final json = ctx.data as Map<String, Object?>;
    final text = json['text']! as String;

    return AiButton(
      text: text,
      onTap: () {
        ctx.dispatchEvent(
          UserActionEvent(
            name: 'ai_button_tapped',
            sourceComponentId: ctx.id,
          ),
        );
      },
    );
  },
);
