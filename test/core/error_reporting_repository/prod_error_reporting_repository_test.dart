// test/core/error_reporting_repository/prod_error_reporting_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:finance_app/core/error_reporting_repository/src/prod_error_reporting_repository.dart';

import 'prod_error_reporting_repository_test.mocks.dart';

@GenerateMocks([Hub])
void main() {
  late MockHub mockHub;
  late ProdErrorReportingRepository repository;

  setUp(() {
    mockHub = MockHub();
    repository = ProdErrorReportingRepository(mockHub);
  });

  group('ProdErrorReportingRepository', () {
    test('init completes successfully', () async {
      await expectLater(repository.init(), completes);
    });

    test('recordError calls Sentry captureException', () async {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      when(mockHub.captureException(
        any,
        stackTrace: anyNamed('stackTrace'),
        hint: anyNamed('hint'),
      )).thenAnswer((_) async => SentryId.newId());

      await repository.recordError(error, stackTrace);

      verify(mockHub.captureException(
        error,
        stackTrace: stackTrace,
        hint: anyNamed('hint'),
      )).called(1);
    });

    test('setUserIdentifier sets user in Sentry', () async {
      when(mockHub.configureScope(any)).thenAnswer((invocation) {
        final callback = invocation.positionalArguments[0] as void Function(Scope);
        callback(Scope(SentryOptions()));
      });

      await repository.setUserIdentifier('test_user_123');

      verify(mockHub.configureScope(any)).called(1);
    });
  });
}