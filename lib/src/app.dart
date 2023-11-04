import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskeleton/src/features/settings/presentation/settings_controller.dart';
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
        scheme: FlexScheme.gold,
        textTheme: GoogleFonts.interTextTheme(),
        appBarElevation: 2.0,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.gold,
        textTheme: GoogleFonts.interTextTheme(),
        appBarElevation: 2.0,
      ),
      themeMode: themeMode,
    );
  }
}
