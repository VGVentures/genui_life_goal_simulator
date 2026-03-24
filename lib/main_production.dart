import 'package:genui_life_goal_simulator/bootstrap.dart';
import 'package:genui_life_goal_simulator/error_reporting/error_reporting.dart';

Future<void> main() async {
  await bootstrap(errorReportingRepository: DevErrorReportingRepository());
}
