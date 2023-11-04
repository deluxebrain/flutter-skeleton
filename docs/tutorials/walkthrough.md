# New flutter project walkthrough

Including:

- Flutter
- Firebase
- Flavors
- Crashlytics
- App icons
- Fastlane

## Create firebase projects

Firebase console:

Create project per app flavor:

- skeleton-app-dev
- skeleton-app-stg
- skeleton-app-prod

Enable Firebase features:

- Authentication:
  - Native providers:
    - Email/Password

## Update all dependencies

```sh
asdf install java latest:temurin
asdf install ruby latest:3
asdf install flutter latest
asdf install firebase latest
```

## Create new project

Note that if xcode is already setup with a provisioning profile this will automatically assign it for iOS signing.

```sh
asdf shell flutter latest && \
flutter create \
    --platforms=android,ios \
    --project-name flutterskeleton \
    --org com.deluxebrain \
    flutter-skeleton

cd flutter-skeleton

git init

asdf local ruby latest:3

gem install cocoapods
# https://stackoverflow.com/questions/77236339/after-updating-cocoapods-to-1-13-0-it-throws-error
gem uninstall --force activesupport
gem install activesupport -v 7.0.8

asdf local java latest:temurin
asdf local flutter latest
asdf local firebase latest

pod setup
```

## Copy over core project files

```text
.vscode/
  launch.json
  settings.json
docs/ (*)
lib/
  l10n/
    arb/
      app_en.arb
scripts/
  configure-firebase
.editorconfig
.gitignore (*)
l10n.yaml
pubspec.yaml*
Makefile

(*) docs
Optional

(*) .gitignore
Overwrite the default

(*) pubspec.yaml
- dependencies
- dev_dependencies
- flutter
  generate: true
```

## Fixup pod versioning

ios/Podfile:

```ruby
# top of file
platform :ios, '12.0'
# ...
# bottom of file
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

ios/Flutter/AppFrameworkInfo.plist:

```plist
  <key>MinimumOSVersion</key>
  <string>12.0</string>
```

xcode:
Runner --> Targets --> Runner --> Minimum Deployments: iOS 12.0

## Code signing

Xcode --> Settings --> Accounts:

- Add apple developer account
- Manage Certificates:
  - Add Apple Development Certificate
  - Add Apple Distribution Certificate

Runner --> Targets --> Runner --> Signing & Capabilities --> Signing:

- Automatically manage signing: Y
- Team: Personal Team

Note: Bundle identifier will need to be globally unique

## Verify app will build

```sh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter build ipa # --no-codesign if no apple developer account
flutter build appbundle
```

## fastlane initialization

```sh
cd ios
fastlane init
# choose option 4 for manual setup

cd ..
cd android
fastlane init
# enter package name
# skip json secret file
# dont download existing metadata
```

## ios/fastlane/Fastfile

```ruby
default_platform(:ios)

platform :ios do
  lane :development do
    build_app(
      scheme: "Runner",
      configuration: "Debug")
  end

  lane :release do
    disable_automatic_code_signing
    build_app(
      scheme: "Runner",
      configuration: "Release")
    enable_automatic_code_signing
    upload_to_testflight
  end
end
```

```sh
cd ios
fastlane ios development
```

## android/fastlane/Fastfile

TODO

## Copy over core application files

```text
assets/
  images/
    app-icon-dev.png
    app-icon-stg.png
    app-icon.png
lib/
  config/
    firebase/
      dev/
      prod/
      stg/
  src/
    common_widgets/
    const/
      store.dart
    features/
    instrumentation/
      logger_console.dart
      logger_firebase.dart
      logger.dart
    l10n/
      l10n.dart
      string_hardcoded.dart
    routing/
    app.dart
  bootstrap.dart
  main_dev.dart
  main_prod.dart
  main_stg.dart
  main.dart DELETE
  flutter_launcher_icons-dev.yaml
  flutter_launcher_icons-prod.yaml
  flutter_launcher_icons-stg.yaml
  flutter_native_splash-dev.yaml
  flutter_native_splash-stg.yaml
  flutter_native_splash-prod.yaml
```

## Add Android flavors

android/app/build.gradle

```gradle
defaultConfig ...

flavorDimensions "default"

productFlavors {
    dev {
        dimension "default"
        applicationIdSuffix ".dev"
        manifestPlaceholders = [appName: "[DEV] FlutterSkeleton"]
    }
    stg {
        dimension "default"
        applicationIdSuffix ".stg"
        manifestPlaceholders = [appName: "[STG] FlutterSkeleton"]
    }
    prod {
        dimension "default"
        applicationIdSuffix ""
        manifestPlaceholders = [appName: "FlutterSkeleton"]
    }
}

buildTypes ...
```

## Add iOS flavors

### Create common configurations settings file

- Runner --> right click --> New File --> Configuration Settings File
  Name as: common.xcconfig
  Save to ios/Flutter
  Group: Runner
  Targets: Runner

- common.xcconfig:

  ```text
  X_APP_NAME=FlutterSkeleton
  X_BUNDLE_NAME=flutterskeleton
  X_BUNDLE_DISPLAY_NAME=FlutterSkeleton
  X_BUNDLE_IDENTIFIER=com.deluxebrain.$(X_BUNDLE_NAME)
  ```

### Create configurations settings file per flavor

- Runner --> right click --> New File --> Configuration Settings File
  Name as: {flavor}.xcconfig
  Save to ios/Flutter
  Group: Runner
  Targets: Runner

- dev.xcconfig

  ```text
  #include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug-dev.xcconfig"
  #include "Generated.xcconfig"
  #include "common.xcconfig"

  X_FLAVOR_NAME=dev
  X_FLAVOR_BUNDLE_SUFFIX=.dev

  X_FLAVOR_APP_NAME=DEV-$(X_APP_NAME)
  X_FLAVOR_BUNDLE_DISPLAY_NAME=DEV-$(X_BUNDLE_DISPLAY_NAME)
  X_FLAVOR_BUNDLE_ID=$(X_BUNDLE_IDENTIFIER)$(X_FLAVOR_BUNDLE_SUFFIX)

  X_FLAVOR_APP_ICON=AppIcon-$(X_FLAVOR_NAME)

  FLUTTER_TARGET=lib/main_$(X_FLAVOR_NAME).dart
  ```

- stg.xcconfig

  ```text
  #include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug-stg.xcconfig"
  #include "Generated.xcconfig"
  #include "common.xcconfig"

  X_FLAVOR_NAME=stg
  X_FLAVOR_BUNDLE_SUFFIX=.stg

  X_FLAVOR_APP_NAME=STG-$(X_APP_NAME)
  X_FLAVOR_BUNDLE_DISPLAY_NAME=STG-$(X_BUNDLE_DISPLAY_NAME)
  X_FLAVOR_BUNDLE_ID=$(X_BUNDLE_IDENTIFIER)$(X_FLAVOR_BUNDLE_SUFFIX)

  X_FLAVOR_APP_ICON=AppIcon-$(X_FLAVOR_NAME)

  FLUTTER_TARGET=lib/main_$(X_FLAVOR_NAME).dart
  ```

- prod.xcconfig

  ```text
  #include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release-prod.xcconfig"
  #include "Generated.xcconfig"
  #include "common.xcconfig"

  X_FLAVOR_NAME=prod
  X_FLAVOR_BUNDLE_SUFFIX=

  X_FLAVOR_APP_NAME=$(X_APP_NAME)
  X_FLAVOR_BUNDLE_DISPLAY_NAME=$(X_BUNDLE_DISPLAY_NAME)
  X_FLAVOR_BUNDLE_ID=$(X_BUNDLE_IDENTIFIER)$(X_FLAVOR_BUNDLE_SUFFIX)

  X_FLAVOR_APP_ICON=AppIcon-$(X_FLAVOR_NAME)

  FLUTTER_TARGET=lib/main_$(X_FLAVOR_NAME).dart
  ```

### Info.plist

- Bundle display name: {blank} ( from Flutterskeleton )
- Bundle name: $(X_BUNDLE_NAME) ( from flutterskeleton )

### Create build configurations

- Runner --> Project --> Runner --> Info --> Configurations
  - Debug-dev
    - Runner: dev
  - Debug-stg
    - Runner: stg
  - Debug-prod (`*`)
    - Runner: prod
  - Release-dev
    - Runner: dev
  - Release-stg
    - Runner: stg
  - Release-prod (`*`)
    - Runner: prod
  - Profile-dev
    - Runner: dev
  - Profile-stg
    - Runner: stg
  - Profile-prod (`*`)
    - Runner: prod

(`*`) renamed existing build configuration

### Add build configurations to Podfile

ios\Podfile

```ruby
project 'Runner', {
  'Debug-dev' => :debug,
  'Debug-stg' => :debug,
  'Debug-prod' => :debug,
  'Profile-dev' => :release,
  'Profile-stg' => :release,
  'Profile-prod' => :release,
  'Release-dev' => :release,
  'Release-stg' => :release,
  'Release-prod' => :release,
}
```

### Create scheme per flavor

Create scheme per flavor:

- dev
- stg
- prod

Edit each scheme:

e.g:
dev:

- Run --> Debug-dev
- Test --> Debug-dev
- Profile --> Profile-dev
- Analyze --> Debug-dev
- Archive --> Release-dev

### target build settings

- Runner --> Targets --> Runner --> Build Settings:
  - Product Bundle Identifier: `$(X_FLAVOR_BUNDLE_ID)`
  - Bundle Display Name: `$(X_FLAVOR_BUNDLE_DISPLAY_NAME)`
  - Product Name: `$(X_FLAVOR_APP_NAME)`
  - Primary App Icon Set Name: `$(X_FLAVOR_APP_ICON)`

### project build settings

- Runner --> Project --> Runner --> Build Settings:
  Supported Platforms: iOS

## Firebase configuration

```sh
./scripts/configure-firebase {dev-project-id} dev com.example.app.dev
./scripts/configure-firebase {stg-project-id} dev com.example.app.stg
./scripts/configure-firebase {prod-project-id} dev com.example.app
```

Verify the following files are created:

```text
android/
  app/
    src/
      dev/
        google-services.json
      stg/
        google-services.json
      prod/
        google-services.json
ios/
  Firebase/
    dev/
      GoogleService-Info.plist
    stg/
      GoogleService-Info.plist
    prod/
      GoogleService-Info.plist
lib/
  config/
    firebase/
      dev/
        firebase_options.dart
      stg/
        firebase_options.dart
      prod/
        firebase_options.dart
```

Verify the following build phases are created:

- FlutterFire: "flutterfire bundle-service-file"
- FlutterFire: "flutterfire upload-crashlytics-symbols"

## Update fastlane to support flavors

### ios

ios/fastlane/Fastfile:

```ruby
default_platform(:ios)

platform :ios do
  lane :development do
    build_app(
      scheme: "dev",
      configuration: "Debug-dev",
      output_directory: "../build/fastlane/ios")
  end

  lane :release do
    disable_automatic_code_signing
    build_app(
      scheme: "prod",
      configuration: "Release-prod",
      output_directory: "../build/fastlane/ios")
    enable_automatic_code_signing
    upload_to_testflight
  end
end

```

### Android

TODO

## Build app icons per flavor

Uses the flutter_launcher_icons configuration files:

- flutter_launcher_icons-dev.yaml
- flutter_launcher_icons-stg.yaml
- flutter_launcher_icons-prod.yaml

```sh
flutter pub run flutter_launcher_icons
```

This will create an icon set (ios) and resources (android) per flavor:

```text
android/
  app/
    src/
      {flavor}/
        res/
ios/
  Runner/
    Assets.xcassets/
      AppIcon-{flavor}.appiconset
```

Add `X_FLAVOR_APP_ICON` to each of your flavor settings files:

- Runner --> Flutter --> {flavor}.xcconfig

E.g:

dev.xcconfig:

```xcconfig
X_FLAVOR_APP_ICON=AppIcon-$(X_FLAVOR_NAME)
```

Update the xcode build settings to use the correct icon set:

- Runner --> Targets --> Runner --> Build Settings --> Primary App Icon Set Name: AppIcon-{flavor}

For some reason you also need to delete the original default icon set or flutter build complains that the app uses the default icons:

- ios/Runner/Assets/xcassets/AppIcon.appiconset

## Build launch screen per flavor

Uses the flutter_native_splash configuration files:

- flutter_native_splash-dev.yaml
- flutter_native_splash-stg.yaml
- flutter_native_splash-prod.yaml

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

## Verify flavors will build

```sh
flutter build ipa --flavor stg -t ./lib/main_dev.dart
flutter build ipa --flavor stg -t ./lib/main_stg.dart
flutter build ipa --flavor prod -t ./lib/main_prod.dart
flutter build appbundle --flavor dev -t ./lib/main_dev.dart
flutter build appbundle --flavor stg -t ./lib/main_stg.dart
flutter build appbundle --flavor prod -t ./lib/main_prod.dart
```

## Verify fastlane

```sh
cd ios
fastlane ios development
```

## Verify flavors will run

Verify app names and icons per flavor.
Verify exceptions get aggregated on Firebase for non-dev flavor.

```sh
flutter run --flavor dev -t ./lib/main_dev.dart
flutter run --flavor stg -t ./lib/main_stg.dart
flutter run --flavor prod -t ./lib/main_prod.dart
```
