# Firebase

## Managing Firebase API keys

Firebase stores Google API keys in the following files(\*):

- lib/firebase_options.dart
- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist

(\*) file paths will be different if using flavors

[According to the official documentation](https://firebase.google.com/docs/projects/api-keys) these keys are not confidential and hence it is safe to commit the corresponding files.

However, any code repo scanning tool is going to flag these files, which leads to exceptions having to configured. ( And more importantly - justified from a compliance perspetive. )

I therefore add these files to the repo `.gitignore`. They are straight-forward to regenerate using `flutterfire configure` and hence do not need backing up in any way.

## Firebase integration

The approach to configuring Firebase is dependent on if the application is using flavors and/or Crashlytics.

- [Firebase configuration without flavors, with or without Crashlytics](#firebase-configuration-without-flavors-with-or-without-crashlytics)
- [Firebase configuration with flavors, without Crashlytics](./firebase-flavors.md)
- [Firebase configuration with flavors, with Crashlytics](./firebase-crashlytics.md)

## Firebase configuration without flavors, with or without Crashlytics

Create project in Firebase console.

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

Add the Firebase project to the Flutter project:

```sh
flutterfire configure
```

This will automatically register a Firebase app for all plaforms configured within the flutter project.

The following files will be created:

- lib/firebase_options.dart
- android/app/google-services.json
- ios/Runner/GoogleService-Info.plist

The `Copy Bundle Resources` build phase will be updated to include `GoogleService-Info.plist`.
