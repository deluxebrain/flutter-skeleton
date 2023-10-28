# App flavors

Flavors ( aka `build configurations` in iOS ) allow a single app codebase to support different environments. This is done through multiple compile-time app configurations, with a specific configuration being selected at runtime.

Notable things this allows:

- Multiple versions of same app to be loaded onto device side-by-side;
- Different icons and look-and-feel per version;
- Different code executions pathways per version ( e.g. per environment logging frameworks);

## Creating app flavors

See:

- [Adding flavors to iOS app](./flavors-ios.md)
- [Adding flavors to Android app](./flavors-android.md)
- [Using flavors with Firebase](./firebase.md)

## Common setup across device families

### App icon

See the corresponding [icons](./icons.md) documentation.

In summary, the `flutter_launcher_icons` package allows for both the iOS and Android app icons to be automatically managed from a single app icon file.

### App entrypoints

Each flavor will map to its own entrypoint.
This is supported by deleting the `lib/main.dart` file and creating flavor specific entrypoints:

- `lib/main_development.dart`
- `lib/main_production.dart`

## Launching app flavor

With all the above changes, a flavor now needs to be specified as part of `flutter run`:

```sh
flutter run --flavor {flavor} -t lib/main_{flavor}.dart
# e.g.
flutter run --flavor development -t lib/main_development.dart
```

## Issues

The following are issues / bugs that need to be addresses in order for flavors to work:

1. Xcode fails to build due to permission issues following setting up flavors
   Ref: [https://github.com/flutter/flutter/issues/128739]
   - Runner --> Targets --> Build Settings --> Build Options --> User Script Sandboxing --> No
