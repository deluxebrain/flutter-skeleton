# Project versioning

Flutter projects are setup to automatically cascade the version from that set in the `pubspec.yaml` file.

This can be verified as follows:

```sh
# build the ios version
flutter build ipa

# check file ios/Flutter/Generated.xcconfig
# FLUTTER_BUILD_NAME
# FLUTTER_BUILD_NUMBER

# build the android version
flutter build appbundle

# check the android/local.properties file
# flutter.buildMode
# flutter.versionName
# flutter.versionCode
```
