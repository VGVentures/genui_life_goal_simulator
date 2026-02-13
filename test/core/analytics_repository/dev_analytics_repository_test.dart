import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DevAnalyticsRepository', () {
    late DevAnalyticsRepository repository;
    late List<String> logMessages;

    void captureLog(String message) {
      logMessages.add(message);
    }

    setUp(() {
      logMessages = [];
      repository = DevAnalyticsRepository(log: captureLog);
    });

    test('init logs initialization message', () async {
      await repository.init();

      expect(logMessages, contains(DevAnalyticsRepository.initLogMessage));
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

    test('setUserId logs the correct userId', () async {
      await repository.setUserId('user123');

      expect(
        logMessages,
        contains('${DevAnalyticsRepository.setUserIdLogMessage} user123'),
      );
    });

    test('setUserId logs null when userId is null', () async {
      await repository.setUserId(null);

      expect(
        logMessages,
        contains('${DevAnalyticsRepository.setUserIdLogMessage} null'),
      );
    });

    test('navigationObserver returns a NavigatorObserver', () {
      expect(repository.navigationObserver, isA<NavigatorObserver>());
    });
  });
}
