# Using flavors with Firebase without Crashlytics

Create project per flavor in firebase console:

E.g.:

- test-app-dev
- test-app-prod

Add firebase core dependencies:

```sh
flutter pub add firebase_core
```

Install flutterfire:

```sh
dart pub global activate flutterfire_cli
```

Log into Firebase:

```sh
firebase login
```

Get id of flavor of firebase project:

```sh
firebase projects:list
```

Add the Firebase project to the Flutter project:

```sh
flutterfire configure \
 --project={id of flavor of project} \
 --out=lib/config/firebase/{flavor}/firebase_options.dart \
 --ios-bundle-id={flavor bundle id} \
 --android-app-id={flavor bundle id}
```

This will automatically register the app flavor for all configured platforms for the corresponding firebase app.

The following files will be created:

- lib/config/firebase/{flavor}/firebase_options.dart
- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist

The `Copy Bundle Resources` build phase will be updated to include `GoogleService-Info.plist`.

Then use correct Firebase options depending on the flavor:

```dart
import 'package:my_app/config/firebase/{flavor}/firebase_options.dart

# await Firebase.initializeApp(options: ...
# DefaultFirebaseOptions.currentPlatform);
```
