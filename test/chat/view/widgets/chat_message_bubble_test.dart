import 'package:finance_app/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:mocktail/mocktail.dart';

class _MockGenUiHost extends Mock implements GenUiHost {}

Future<void> _pump(
  WidgetTester tester,
  ChatMessage message,
  GenUiHost host,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ChatMessageBubble(message: message, host: host),
      ),
    ),
  );
}

void main() {
  late _MockGenUiHost host;

  setUp(() {
    host = _MockGenUiHost();
  });

  group(ChatMessageBubble, () {
    group('renders', () {
      testWidgets('user bubble for $UserMessage', (tester) async {
        await _pump(tester, UserMessage.text('Hello'), host);

        expect(find.text('Hello'), findsOneWidget);

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.centerRight);
      });

      testWidgets('assistant bubble for $AiTextMessage', (tester) async {
        await _pump(tester, AiTextMessage.text('Hi there'), host);

        expect(find.text('Hi there'), findsOneWidget);

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.centerLeft);
      });
    });
  });
}
