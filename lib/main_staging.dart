import 'package:finance_app/app/app.dart';
import 'package:finance_app/bootstrap.dart';
import 'package:finance_app/core/error_reporting_repository/error_reporting_repository.dart';

Future<void> main() async {
  await bootstrap(
    builder: () => const App(),
    errorReportingRepository: DevErrorReportingRepository(),
  );
}
