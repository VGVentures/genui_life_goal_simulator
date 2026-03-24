import 'package:flutter_test/flutter_test.dart';
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';

void main() {
  late DevErrorReportingRepository repository;
  late List<String> logs;

  setUp(() {
    logs = [];
    repository = DevErrorReportingRepository(log: logs.add);
  });

  group('DevErrorReportingRepository', () {
    test('recordError logs error without throwing', () async {
      const error = 'ERROR';
      final stackTrace = StackTrace.fromString('STACK TRACE');
      await expectLater(
        repository.recordError(
          error,
          stackTrace,
          reason: 'Test reason',
          extra: {'key': 'value'},
        ),
        completes,
      );
      expect(logs, [
        'ERROR',
        'STACK TRACE',
      ]);
    });
  });
}
