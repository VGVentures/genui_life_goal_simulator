import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DevAnalyticsRepository', () {
    late DevAnalyticsRepository repository;
    late List<String> logMessages;

    setUp(() {
      logMessages = [];
      repository = DevAnalyticsRepository(log: logMessages.add);
    });

    test('trackEvent logs event name and parameters', () async {
      await repository.trackEvent('test_event', parameters: {'key': 'value'});

      expect(
        logMessages,
        contains(
          '${DevAnalyticsRepository.trackEventLogMessage} test_event, '
          'parameters: {key: value}',
        ),
      );
    });

    test('trackEvent logs event without parameters', () async {
      await repository.trackEvent('test_event');

      expect(
        logMessages,
        contains(
          '${DevAnalyticsRepository.trackEventLogMessage} test_event, '
          'parameters: null',
        ),
      );
    });

    test('navigatorObserver returns a NavigatorObserver', () {
      expect(repository.navigatorObserver, isA<NavigatorObserver>());
    });
  });
}
