import 'package:flutter/foundation.dart';
import 'package:flutterskeleton/src/instrumentation/logger.dart';
import 'package:logger/logger.dart' as logger;
import 'package:riverpod_annotation/riverpod_annotation.dart';

typedef _Logger = logger.Logger;

class LoggerConsole implements Logger {
  LoggerConsole(this._logger);

  final _Logger _logger;

  @override
  FutureOr<void> log(String message) {
    _logger.i(message);
  }

  @override
  FutureOr<void> recordError(dynamic error, StackTrace? stackTrace) {
    _logger.e(error.toString(), error: error, stackTrace: stackTrace);
  }

  @override
  FutureOr<void> recordFatalError(dynamic error, StackTrace? stackTrace) {
    _logger.f(error.toString(), error: error, stackTrace: stackTrace);
  }

  @override
  FutureOr<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) {
    _logger.e(flutterErrorDetails.exceptionAsString(),
        error: flutterErrorDetails.exception);
  }

  @override
  FutureOr<void> recordFlutterFatalError(
      FlutterErrorDetails flutterErrorDetails) {
    _logger.f(flutterErrorDetails.exceptionAsString(),
        error: flutterErrorDetails.exception);
  }
}

final loggerConsoleProvider = Provider<LoggerConsole>((ref) {
  return LoggerConsole(ref.watch(_consoleLoggerProvider));
});

// Riverpod generator will not work here due to name collision
final _consoleLoggerProvider = Provider<_Logger>((ref) {
  return _Logger(
    printer: logger.PrettyPrinter(
      colors: true, // stdout.supportsAnsiEscapes is not reliable,
    ),
  );
});
