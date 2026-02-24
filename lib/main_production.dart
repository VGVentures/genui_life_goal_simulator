import 'package:finance_app/bootstrap.dart';
import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wiredash/wiredash.dart';

Future<void> main() async {
  if (kDebugMode) {
    // Debug mode: Use console logging, skip Sentry initialization
    await _bootstrap(DevErrorReportingRepository());
  } else {
    await SentryFlutter.init(
      (options) {
        options
          ..dsn =
              'https://75a71ac4db863a4e5fb99a10ca1d9343@o4510874275872768.ingest.us.sentry.io/4510874315390976'
          ..tracesSampleRate = 1.0
          ..environment = 'production';
      },
      appRunner: () => _bootstrap(ProdErrorReportingRepository(HubAdapter())),
    );
  }
}

Future<void> _bootstrap(ErrorReportingRepository errorReportingRepository) {
  return bootstrap(
    errorReportingRepository: errorReportingRepository,
    analyticsRepositoryFactory: () => ProdAnalyticsRepository(
      firebaseAnalytics: FirebaseAnalytics.instance,
      wiredashAnalytics: WiredashAnalytics(),
    ),
  );
}
