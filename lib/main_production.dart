import 'package:finance_app/bootstrap.dart';
import 'package:finance_app/core/analytics_repository/analytics_repository.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:wiredash/wiredash.dart';

Future<void> main() async {
  await bootstrap(
    errorReportingRepository: ProdErrorReportingRepository(),
    analyticsRepository: ProdAnalyticsRepository(
      firebaseAnalytics: FirebaseAnalytics.instance,
      wiredashAnalytics: WiredashAnalytics(),
    ),
  );
}
