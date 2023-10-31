# App launch image

App launch images are managed using `flutter_launcher_icons`.

This automatically creates the app splash screen as well as allowing it to be held whilst the application specific initialization is performed.

This guide assumes the app is using flavors and all flavor related setup and configuration is complete.

## `flutter_launcher_icons` installation

The `flutter_launcher_icons` package performs two duties:

- Generation and configuration of launch images
- Support for holding splash screen until customer initialization is complete

Install as a dev dependency for just the former functionality. Hold support requires installation as production dependency.

## Configuring the splash screen

Create a configuration file per flavor in the form `flutter_native_splash-{flavor}`.yaml

E.g:

- flutter_native_splash-dev.yaml
- flutter_native_splash-stg.yaml
- flutter_native_splash-prod.yaml

flutter_native_splash-dev.yaml:

```yaml
flutter_native_splash:
  # use color or background_image
  color: "#ffffff"
  # background_image:
  # fullscreen: true

  # image should be your logo
  image: assets/images/app-icon-dev.png

  color_dark: "#121212"
  # background_image_dark:
  # fullscreen: true
  image_dark: assets/images/app-icon-dev.png

  # android 12 specific configuration
  android_12:
    image: assets/images/app-icon-dev.png
    icon_background_color: "#ffffff"
    image_dark: assets/images/app-icon-dev.png
    icon_background_color_dark: "#121212"

  # disable generation of web splash
  web: false
```

- `color`: background color of the splash screen
- `background_image`: background image of the splash screen
- `full_screen`: hide notification bar
- `image`: generally your app icon, displayed centered
- `brand`: for placing branding image, by default at bottom
- `*_dark`: override corresponding config element in darkmode
- `android_12`: android 12 uses its own approach

Then generate the launch assets as follows:

```sh
dart run flutter_native_splash:create --flavors dev,stg,prod
```

The following files are created:

```text
android\
  src\
    dev\
      res\
    stg\
      res\
    prod\
      res\
ios\
  Runner\
    Base.lproj\
      LaunchScreenDev.storyboard
      LaunchScreenStg.storyboard
      LaunchScreenProd.storyboard
```

## Android configuration

Nothing further todo

## iOS configuration

Add the launch screen storyboards to xcode:

- Runner --> Runner --> "Add Files to Runner..."
  - ensure "Copy items if needed" is checked
  - add to targets: Runner
  - add all launch screen storyboards for your flavors:
    - ios\Runner\Base.lproj\LaunchScreenDev.storyboard
    - ios\Runner\Base.lproj\LaunchScreenStg.storyboard
    - ios\Runner\Base.lproj\LaunchScreenProd.storyboard

Configure your targets to use the launch screen story boards:

Add `X_FLAVOR_LAUNCH_SCREEN` to each of your flavor settings files:

- Runner --> Flutter --> {flavor}.xcconfig

E.g:

dev.xcconfig:

```xcconfig
# DO NOT INCLUDE .storyboard file extension
X_FLAVOR_LAUNCH_SCREEN=LaunchScreenDev
```

- Runner --> Runner --> Info.plist:
  - Launch screen interface file base name: $(X_FLAVOR_LAUNCH_SCREEN)

## Code changes

No code changes required unless you want support for holding the launch image during app initialization.

To hold the splash screen:

E.g. in main.dart

```dart
final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
```

To remove the splash screen:

E.g. in home_screen.dart

```dart
class HomeScreen extends StatefulWidget {
  ...
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initializeAppState();
  }

  void initializeAppState() async {
    // Perform app initialization
    await Future.delayed(const Duration(seconds: 3));

    // Remove launch screen
    FlutterNativeSplash.remove();
  }
```

## Updating app launch image

Recreate the launch images:

```sh
dart run flutter_native_splash:create --flavors dev,stg,prod
```

Clear device caches:

- Delete app from device
- Restart device
