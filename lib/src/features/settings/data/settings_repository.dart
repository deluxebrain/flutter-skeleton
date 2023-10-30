import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/const/store.dart';
import 'package:flutterskeleton/src/features/settings/domain/settings.dart';
import 'package:flutterskeleton/src/utils/shared_preferences_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  SettingsRepository(this._sharedPreferences);
  final SharedPreferences _sharedPreferences;

  Settings getSettings() {
    return Settings(
        themeMode: _sharedPreferences.getGeneric(
      Store.keyThemeMode,
      Store.defaultThemeMode,
    ));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _sharedPreferences.setGeneric(Store.keyThemeMode, themeMode);
  }
}

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  throw UnimplementedError();
}
