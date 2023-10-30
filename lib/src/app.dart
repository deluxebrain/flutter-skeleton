import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskeleton/src/features/settings/presentation/settings_controller.dart';
import 'package:flutterskeleton/src/instrumentation/logger.dart';
import 'package:flutterskeleton/src/l10n/l10n.dart';
import 'package:flutterskeleton/src/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch for updates to theme mode
    final themeMode = ref.watch(
        settingsControllerProvider.select((settings) => settings.themeMode));

    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (BuildContext context) => context.l10n.appTitle,
      theme: FlexThemeData.light(
        scheme: FlexScheme.sakura,
        textTheme: GoogleFonts.aldrichTextTheme(),
        appBarElevation: 2.0,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.sakura,
        textTheme: GoogleFonts.aldrichTextTheme(),
        appBarElevation: 2.0,
      ),
      themeMode: themeMode,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logger = ref.read(loggerProvider);
    logger.log('Building HomePage');

    // watch for updates to theme mode
    final themeMode = ref.watch(
        settingsControllerProvider.select((settings) => settings.themeMode));

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(themeMode.name),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () {
                throw Exception('Throw FOO');
              },
              child: const Text('Throw FOO'),
            ),
            TextButton(
              onPressed: () {
                throw Exception('Throw BAR');
              },
              child: const Text('Throw BAR'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateSettings(themeMode: ThemeMode.dark);
              },
              child: const Text('Dark Mode'),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(settingsControllerProvider.notifier)
                    .updateSettings(themeMode: ThemeMode.light);
              },
              child: const Text('Light Mode'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
