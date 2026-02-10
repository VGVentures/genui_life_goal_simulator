import 'package:finance_app/app/app.dart';
import 'package:finance_app/bootstrap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'firebase_options.dart';

Future<void> main() async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await bootstrap(() => const App());
}
