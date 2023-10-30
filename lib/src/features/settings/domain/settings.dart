import 'package:flutter/material.dart';

class Settings {
  Settings({required themeMode}) : _themeMode = themeMode;

  Settings copyWith({
    ThemeMode? themeMode,
  }) {
    return Settings(
      themeMode: themeMode ?? _themeMode,
    );
  }

  final ThemeMode _themeMode;

  ThemeMode get themeMode {
    return _themeMode;
  }
}
