import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wiredash/wiredash.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockWiredashAnalytics extends Mock implements WiredashAnalytics {}

void main() {
  group('ProdAnalyticsRepository', () {
    late ProdAnalyticsRepository repository;
    late MockFirebaseAnalytics mockFirebaseAnalytics;
    late MockWiredashAnalytics mockWiredashAnalytics;

    void stubFirebaseLogEvent() {
      when(
        () => mockFirebaseAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});
    }

    void stubWiredashTrackEvent() {
      when(
        () => mockWiredashAnalytics.trackEvent(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async {});
    }

    setUp(() {
      mockFirebaseAnalytics = MockFirebaseAnalytics();
      mockWiredashAnalytics = MockWiredashAnalytics();

      repository = ProdAnalyticsRepository(
        firebaseAnalytics: mockFirebaseAnalytics,
        wiredashAnalytics: mockWiredashAnalytics,
      );
    });

    group('trackEvent', () {
      setUp(() {
        stubFirebaseLogEvent();
        stubWiredashTrackEvent();
      });

      test('delegates to FirebaseAnalytics and WiredashAnalytics', () async {
        await repository.trackEvent('test_event', parameters: {'key': 'value'});

        verify(
          () => mockFirebaseAnalytics.logEvent(
            name: 'test_event',
            parameters: {'key': 'value'},
          ),
        ).called(1);

        verify(
          () => mockWiredashAnalytics.trackEvent(
            'test_event',
            data: {'key': 'value'},
          ),
        ).called(1);
      });

      test('delegates without parameters', () async {
        await repository.trackEvent('test_event');

        verify(
          () => mockFirebaseAnalytics.logEvent(name: 'test_event'),
        ).called(1);

        verify(
          () => mockWiredashAnalytics.trackEvent('test_event'),
        ).called(1);
      });
    });
  });
}
