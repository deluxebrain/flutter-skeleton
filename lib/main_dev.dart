import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskeleton/bootstrap.dart';
import 'package:flutterskeleton/config/firebase/dev/firebase_options.dart';
import 'package:flutterskeleton/src/app.dart';
import 'package:flutterskeleton/src/instrumentation/logger.dart';
import 'package:flutterskeleton/src/instrumentation/logger_console.dart';

Future<void> main() async {
  bootstrap(
    _buildFirebase,
    _buildContainer,
    () => const MyApp(),
  );
}

Future<FirebaseApp> _buildFirebase() async {
  return await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

ProviderContainer _buildContainer() {
  return ProviderContainer(
    overrides: [
      loggerProvider.overrideWith(
        (ref) => ref.watch(loggerConsoleProvider),
      )
    ],
  );
}
