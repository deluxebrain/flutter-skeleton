import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterskeleton/src/instrumentation/logger.dart';
import 'package:flutterskeleton/src/l10n/string_hardcoded.dart';

Future<void> bootstrap(
  Future<FirebaseApp> Function() firebaseBuilder,
  Future<ProviderContainer> Function() containerBuilder,
  FutureOr<Widget> Function() appBuilder,
) async {
  late ProviderContainer? container;

  runZonedGuarded(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    // hold the launch image until explicitly removed
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await firebaseBuilder();

    container = await containerBuilder();

    registerErrorHandlers(container!);

    runApp(UncontrolledProviderScope(
      container: container!,
      child: await appBuilder(),
    ));
  }, (error, stack) {
    final logger = container?.read(loggerProvider);
    logger?.recordFatalError(error, stack);
  });
}

void registerErrorHandlers(ProviderContainer container) {
  final logger = container.read(loggerProvider);

  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails flutterErrorDetails) {
    FlutterError.presentError(flutterErrorDetails); // dump to device logs
    logger.recordFlutterFatalError(flutterErrorDetails);

    // quit application if in release mode
    if (kReleaseMode) exit(1);
  };

  // Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logger.recordFatalError(error, stack);
    return true;
  };

  // Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('An error occurred'.hardcoded),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}
