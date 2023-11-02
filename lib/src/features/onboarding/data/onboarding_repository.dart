import 'package:flutterskeleton/src/const/store.dart';
import 'package:flutterskeleton/src/utils/shared_preferences_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_repository.g.dart';

class OnboardingRepository {
  OnboardingRepository(this._sharedPreferences);
  final SharedPreferences _sharedPreferences;

  bool onboardingComplete() => _sharedPreferences.getGeneric(
        Store.keyOnboardingComplete,
        Store.defaultOnboardingComplete,
      );

  Future<void> setOnboardingComplete(bool onboardingComplete) async {
    await _sharedPreferences.setGeneric(
        Store.keyOnboardingComplete, onboardingComplete);
  }
}

@riverpod
OnboardingRepository onboardingRepository(OnboardingRepositoryRef ref) {
  throw UnimplementedError();
}
