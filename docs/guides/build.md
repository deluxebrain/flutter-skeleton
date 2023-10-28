# Build

## Build artecfacts

Build artefacts and locations are dependent on how the build was performed:

### flutter build

```sh
flutter build ipa --flavor dev -t ./lib/main_dev.dart
```

```text
build/
  ios/
    ipa/
      flutterskeleton.ipa
```

### flutter run

```sh
flutter run --flavor dev -t ./lib/main_dev.dart
```

```text
build/
  ios/
    iphonesimulator/
      DEV-FlutterSkeleton.app
```

### fastlane

```sh
# output_directory: "../build/fastlane/ios"
fastlane ios development
```

```text
build/
  ios/
    fastlane/
      DEV-FlutterSkeleton.app.dSYM.zip
      DEV-FlutterSkeleton.ipa

```

## Fastlane

### Installation

Each platform is managed through its own `Fastfile` within the platform sub-directory ( e.g. `ios\fastlane\Fastfile` ).

The platform `fastlane` directory has a Gemfile in it that installs fastlane.
So Im guessing the following:

- from a local dev perspective, just install fastlane however you want
- from a ci/cd perspective, fastlane will be installed per platform using `bundler`.

For the sake of this project I'm install fastlane using brew ( `brew install fastlane` ).

### Per-platform initialization

From the command line and for each platform:

- navigate into the platform top-level directory
- execute the command `fastlane init`
- answer no ( or corresponding reply ) to force manual task setup.

e.g:

```sh
cd ios
fastlane init
```

This creates the following directory structure:

```text
{platform}\
  fastlane\
    Appfile   # application metadata ( e.g. package name)
    Fastfile  # task definitions
```
