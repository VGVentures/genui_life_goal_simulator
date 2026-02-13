import 'package:finance_app/app/app.dart';
import 'package:finance_app/bootstrap.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://75a71ac4db863a4e5fb99a10ca1d9343@o4510874275872768.ingest.us.sentry.io/4510874315390976'; // ← Pega tu DSN de Sentry aquí
      options.tracesSampleRate = 1.0;
      options.environment = 'production';
    },
    appRunner: () => bootstrap(
      builder: () => const App(),
      errorReportingRepository: ProdErrorReportingRepository(
        HubAdapter(), // ← Esto conecta con Sentry
      ),
    ),
  );
}
