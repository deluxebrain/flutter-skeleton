import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logger.g.dart';

abstract class Logger {
  FutureOr<void> log(String message);

  FutureOr<void> recordError(dynamic error, StackTrace? stackTrace);

  FutureOr<void> recordFatalError(dynamic error, StackTrace? stackTrace);

  FutureOr<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails);

  FutureOr<void> recordFlutterFatalError(
      FlutterErrorDetails flutterErrorDetails);
}

@Riverpod()
Logger logger(LoggerRef ref) {
  throw UnimplementedError();
}
