import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/features/settings/data/settings_repository.dart';
import 'package:flutterskeleton/src/features/settings/domain/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Settings build() {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  void updateSettings({
    ThemeMode? themeMode,
  }) {
    final settingsRepository = ref.read(settingsRepositoryProvider);
    final updatedSettings = state.copyWith(
      themeMode: themeMode,
    );
    state = updatedSettings;
    // fire-and-forget
    if (themeMode != null) {
      settingsRepository.setThemeMode(themeMode);
    }
  }
}
