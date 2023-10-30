import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskeleton/bootstrap.dart';
import 'package:flutterskeleton/config/firebase/dev/firebase_options.dart';
import 'package:flutterskeleton/src/app.dart';
import 'package:flutterskeleton/src/features/settings/data/settings_repository.dart';
import 'package:flutterskeleton/src/instrumentation/logger.dart';
import 'package:flutterskeleton/src/instrumentation/logger_console.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<ProviderContainer> _buildContainer() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  return ProviderContainer(
    overrides: [
      loggerProvider.overrideWith(
        (ref) => ref.watch(loggerConsoleProvider),
      ),
      settingsRepositoryProvider.overrideWithValue(
        SettingsRepository(sharedPreferences),
      )
    ],
  );
}
