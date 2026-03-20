import 'package:vgv_genui_financial_advisor/bootstrap.dart';
import 'package:vgv_genui_financial_advisor/error_reporting/error_reporting.dart';

Future<void> main() async {
  await bootstrap(
    errorReportingRepository: DevErrorReportingRepository(),
    showDevMenu: true,
  );
}
