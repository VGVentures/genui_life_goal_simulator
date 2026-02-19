import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MockHub extends Mock implements Hub {}

void main() {
  late MockHub mockHub;
  late ProdErrorReportingRepository repository;

  setUp(() {
    mockHub = MockHub();
    repository = ProdErrorReportingRepository(mockHub);
  });

  group('ProdErrorReportingRepository', () {
    test('recordError calls Sentry captureException', () async {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      when(
        () => mockHub.captureException(
          any<dynamic>(),
          stackTrace: any<StackTrace?>(named: 'stackTrace'),
          hint: any<Hint?>(named: 'hint'),
        ),
      ).thenAnswer((_) async => SentryId.newId());

      await repository.recordError(error, stackTrace);

      verify(
        () => mockHub.captureException(
          error,
          stackTrace: stackTrace,
          hint: any<Hint?>(named: 'hint'),
        ),
      ).called(1);
    });
  });

  group('handleFlutterError', () {
    test('captures Flutter error with context', () {
      final exception = Exception('Widget error');
      final stack = StackTrace.current;
      final details = FlutterErrorDetails(
        exception: exception,
        stack: stack,
        library: 'flutter',
        context: ErrorDescription('building widget'),
      );

      when(
        () => mockHub.captureException(
          any<dynamic>(),
          stackTrace: any<StackTrace?>(named: 'stackTrace'),
          hint: any<Hint?>(named: 'hint'),
        ),
      ).thenAnswer((_) async => SentryId.newId());

      repository.handleFlutterError(details);

      verify(
        () => mockHub.captureException(
          exception,
          stackTrace: stack,
          hint: any<Hint?>(named: 'hint'),
        ),
      ).called(1);
    });
  });

  group('handlePlatformError', () {
    test('captures platform error and returns true', () {
      final error = Exception('Platform error');
      final stackTrace = StackTrace.current;

      when(
        () => mockHub.captureException(
          any<dynamic>(),
          stackTrace: any<StackTrace?>(named: 'stackTrace'),
          hint: any<Hint?>(named: 'hint'),
        ),
      ).thenAnswer((_) async => SentryId.newId());

      final result = repository.handlePlatformError(error, stackTrace);

      expect(result, true);
      verify(
        () => mockHub.captureException(
          error,
          stackTrace: stackTrace,
          hint: any<Hint?>(named: 'hint'),
        ),
      ).called(1);
    });
  });
}
