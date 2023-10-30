import 'package:flutter/material.dart';
import 'package:flutterskeleton/src/utils/type_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesX on SharedPreferences {
  T getGeneric<T>(String key, T defaultValue) {
    try {
      debugPrint('SharedPrefs has type: '
          '$key as ${defaultValue.runtimeType}');

      // T is String
      if (T.sameTypeAs<T, String>()) {
        final String value = getString(key) ?? defaultValue as String;
        debugPrint('SharedPrefs loaded type String: $key as $value');
        return value as T;
      }
      // T is ThemeMode
      if (T.sameTypeAs<T, ThemeMode>()) {
        final int? value = getInt(key);
        debugPrint('SharedPrefs loaded type ThemeMode: $key as $value');
        if (value == null) return defaultValue;
        if (value < 0) return defaultValue;
        if (value >= ThemeMode.values.length) return defaultValue;
        return ThemeMode.values[value] as T;
      }
    } catch (e) {
      debugPrint('SharedPrefs load ERROR');
      debugPrint('Store key: $key');
      debugPrint('defaultValue: $defaultValue');
      debugPrint('Error message: $e');
      return defaultValue;
    }
    debugPrint('WARNING: SharedPrefs no type converter for type: '
        '$key as ${defaultValue.runtimeType}');
    return defaultValue;
  }

  Future<void> setGeneric<T>(String key, T value) async {
    try {
      // T is String
      if (T.sameTypeAs<T, String>()) {
        await setString(key, value as String);
        debugPrint('SharedPrefs saved type String: $key as $value');
      }
      // T is int
      if (T.sameTypeAs<T, int>()) {
        await setInt(key, value as int);
        debugPrint('SharedPrefs saved type int: $key as $value');
      }
      // T is ThemeMode
      if (T.sameTypeAs<T, ThemeMode>()) {
        await setInt(key, (value as ThemeMode).index);
        debugPrint('SharedPrefs saved type int: $key as ${value.index}');
      }
      // T is Enum
      if (T is Enum) {
        await setInt(key, (value as Enum).index);
        debugPrint('SharedPrefs saved type Enum: $key as $value');
      }
    } catch (e) {
      debugPrint('SharedPrefs load ERROR');
      debugPrint('Store key: $key');
      debugPrint('Store value: $value');
      debugPrint('Error message: $e');
    }
  }
}
