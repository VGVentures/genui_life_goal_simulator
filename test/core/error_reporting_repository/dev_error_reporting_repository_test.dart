import 'package:flutter_test/flutter_test.dart';
import 'package:finance_app/core/error_reporting_repository/src/dev_error_reporting_repository.dart';

void main() {
  late DevErrorReportingRepository repository;

  setUp(() {
    repository = DevErrorReportingRepository();
  });

  group('DevErrorReportingRepository', () {
    test('init completes successfully', () async {
      await expectLater(repository.init(), completes);
    });

    test('recordError logs error without throwing', () async {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      await expectLater(
        repository.recordError(
          error,
          stackTrace,
          reason: 'Test reason',
          extra: {'key': 'value'},
        ),
        completes,
      );
    });

    test('setUserIdentifier stores identifier', () async {
      await expectLater(
        repository.setUserIdentifier('user123'),
        completes,
      );
    });

    test('setUserIdentifier with null', () async {
      await expectLater(
        repository.setUserIdentifier(null),
        completes,
      );
    });
  });
}
