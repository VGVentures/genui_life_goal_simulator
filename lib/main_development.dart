import 'package:finance_app/app/app.dart';
import 'package:finance_app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
