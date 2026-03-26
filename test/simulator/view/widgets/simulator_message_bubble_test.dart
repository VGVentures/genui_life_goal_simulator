import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_life_goal_simulator/simulator/simulator.dart';
import 'package:mocktail/mocktail.dart';

class _MockSurfaceHost extends Mock implements SurfaceHost {}

Future<void> _pump(
  WidgetTester tester,
  DisplayMessage message,
  SurfaceHost host,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SimulatorMessageBubble(message: message, host: host),
      ),
    ),
  );
}

void main() {
  late _MockSurfaceHost host;

  setUp(() {
    host = _MockSurfaceHost();
  });

  group(SimulatorMessageBubble, () {
    group('renders', () {
      testWidgets('user bubble for $UserDisplayMessage', (tester) async {
        await _pump(tester, const UserDisplayMessage('Hello'), host);

        expect(find.text('Hello'), findsOneWidget);

        final align = tester.widget<Align>(find.byType(Align));
        expect(align.alignment, Alignment.centerRight);
      });

      testWidgets('assistant text for $AiTextDisplayMessage', (tester) async {
        await _pump(tester, const AiTextDisplayMessage('Hi there'), host);

        expect(find.text('Hi there'), findsOneWidget);
      });
    });
  });
}
