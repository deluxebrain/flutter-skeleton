import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterskeleton/src/instrumentation/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger_firebase.g.dart';

class LoggerFirebase implements Logger {
  LoggerFirebase(this._firebaseCrashlytics);

  final FirebaseCrashlytics _firebaseCrashlytics;

  @override
  FutureOr<void> log(String message) {
    _firebaseCrashlytics.log(message);
  }

  @override
  FutureOr<void> recordError(dynamic error, StackTrace? stackTrace) {
    _firebaseCrashlytics.recordError(error, stackTrace, fatal: false);
  }

  @override
  FutureOr<void> recordFatalError(dynamic error, StackTrace? stackTrace) {
    _firebaseCrashlytics.recordError(error, stackTrace, fatal: true);
  }

  @override
  FutureOr<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) {
    _firebaseCrashlytics.recordFlutterError(flutterErrorDetails);
  }

  @override
  FutureOr<void> recordFlutterFatalError(
      FlutterErrorDetails flutterErrorDetails) {
    _firebaseCrashlytics.recordFlutterFatalError(flutterErrorDetails);
  }
}

@Riverpod()
LoggerFirebase loggerFirebase(LoggerFirebaseRef ref) {
  return LoggerFirebase(ref.watch(firebaseCrashlyticsProvider));
}

@Riverpod(keepAlive: true)
FirebaseCrashlytics firebaseCrashlytics(FirebaseCrashlyticsRef ref) {
  return FirebaseCrashlytics.instance;
}
