// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:finance_app/app/app.dart';
import 'package:finance_app/counter/counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
