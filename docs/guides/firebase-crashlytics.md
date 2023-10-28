# Crashlytics

Crashlytics is fundamentally about crash reporting and trend analysis.

Errors can be reported as fatal or not, with the latter not impacting the crash-free users statistic.

Log entries can also be made, but note that these are only available as part of crash reporting.

> Logs should therefore only be used to provide additional context to help with crash debugging.

## Uploading dSYM file to firebase

The Crashlytics package automatically uploads the app dSYM file to provide human readable stack trace.

For the iOS app, this is performed by a custom script that `flutterfire configure` adds to the project xcode build phases.

## Configuring firebase and crashlytics with flavors

> Configuring firebase and crashlytics with flutter flavors is not very well documented. The following approach is based on [this github issues discussion](https://github.com/invertase/flutterfire_cli/issues/14). The approach requires a pre-release version of the `flutterfire cli`.

See the following gotchas associated with this approach:

- [Bug when using spaces in application name](./gotchas.md#bug-with-spaces-in-application-name)
- [Bug with iOS Simulator deployment target](./gotchas.md#bug-with-ios-simulator-deployment-target)

Create project per flavor in firebase console:

E.g.:

- test-app-dev
- test-app-prod

Add firebase dependencies:

```sh
flutter pub add firebase_core
flutter pub add firebase_crashlytics
```

Install latest dev version of the flutterfire cli:

```sh
# see: https://pub.dev/packages/flutterfire_cli/versions
dart pub global activate flutterfire_cli 0.3.0-dev.18 --overwrite
```

Log into Firebase:

```sh
firebase login
```

Get id of flavor of firebase project:

```sh
firebase projects:list
```

Add the Firebase project to the Flutter project for each build configuration.
Approach based on [this github issue contribution](https://github.com/invertase/flutterfire_cli/issues/14#issuecomment-1463682721).

```sh
# e.g. if:
# Call for each of your flavors
local account # email address associated with firebase account
local project # id of firebase project for flavor
local flavor # e.g. development
local bundle_id # bundle id for corresponding flavor
for prefix in "Debug" "Release" "Profile"; do
 echo 'yes' | flutterfire configure \
   --account="$account" \
   --project="$project" \
   --out="lib/config/firebase/$flavor/firebase_options.dart" \
   --android-out="/android/app/src/$flavor/google-services.json" \
   --ios-bundle-id="$bundle_id" \
   --android-package-name="$bundle_id" \
   --ios-out="/ios/Firebase/$flavor/GoogleService-Info.plist" \
   --ios-build-config="$prefix-$flavor" \
   --yes
done
```

This will automatically register the app flavor for all configured platforms for the corresponding firebase app.

The following files will be created:

- lib/config/firebase/{flavor}/firebase_options.dart
- android/app/src/{flavor}/google-services.json
- ios/Firebase/{flavor}/GoogleService-Info.plist

Two new build phases added:

1. FlutterFire: "flutterfire bundle-service-file"

   Uses `flutterfire bundle-service-file` to copy the iOS GoogleService-Info.plist file for the corresponding flavor into the correct build location.

2. FlutterFire: "flutterfire upload-crashlytics-symbols"

   Uses `flutterfire upload-crashlytics-symbols` to upload iOS dSYM file to firebase.

> No update to the `Copy Bundle Resources` build phase.

Then use correct Firebase options depending on the flavor:

```dart
import 'package:my_app/config/firebase/{flavor}/firebase_options.dart

# await Firebase.initializeApp(options: ...
# DefaultFirebaseOptions.currentPlatform);
```
