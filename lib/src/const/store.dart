import 'package:flutter/material.dart';

class Store {
  // private constructor to prevent class instantiation
  Store._();

  static const String keyThemeMode = 'themeMode';
  static const ThemeMode defaultThemeMode = ThemeMode.system;

  static const String keyOnboardingComplete = 'onboardingComplete';
  static const bool defaultOnboardingComplete = false;
}
