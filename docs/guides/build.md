# Build

NOTE this guide is focused on iOS targets.

## CLI build tools

Regardless of how builds are orchestrated ( xcode, flutter build, fastlane, etc) the build will be performed using `xcodebuild`.

> However, each will use xcodebuild in a slightly different way which can cause confusion.

When `flutter build` calls `xcodebuild` it hides all the build output, and just reports orchestration events and errors.

When `fastlane ios` calls `xcodebuild` it ( by default ) shows all the build output, as well as orchestration events and errors.

Due to the complexity of flutter, calling into pods which depends on c++ libraries, etc, etc, the build output will often contain ( lots ) of compiler warnings. To be explicit:

> fastlane will show the compiler warnings whereas flutter build will not

Note that neither flutter nor fastlane are configured to treat warnings as errors.

## Dealing with compiler warnings

Although fastlane does not treat warnings as errors, in certain situations warnings effectively break the build.

For example, bringing in `firestore` dependencies ( as of time of writing ) bring in the `abseil` framework ( via the abseil pod ) which leads to the following warnings being generated. Note that this warnings are so numerous so as the slow the build times down to a point where it is effectively broken.

```sh
[15:19:57]: ▸ ⚠️  /Users/deluxebrain/Library/Developer/Xcode/DerivedData/Runner-gzrfilvdjgmhdzgxofaluqqacrfw/Build/Intermediates.noindex/ArchiveIntermediates/Runner/BuildProductsPath/Release-iphoneos/abseil/absl.framework/Headers/meta/type_traits.h:301:36: builtin __has_trivial_destructor is deprecated; use __is_trivially_destructible instead [-Wdeprecated-builtins]
[15:19:57]: ▸     : std::integral_constant<bool, __has_trivial_destructor(T) &&
[15:19:57]: ▸
```

Fastlane provides two approaches to dealing with this.

### Silencing all xcodebuild output

There is an argument for just silencing all xcodebuild output as this is what flutter appears todo.

This can be done as follows:

```ruby
lane :development do
  build_app(
    suppress_xcode_output: true,
    scheme: "Runner",
    configuration: "Debug")
end
```

### Turn off specific compiler warnings

Alternatively, the offending warning can be silenced by passing it through as a compiler option.

For example, the above warning output shows that it is being generated due to the `-Wdeprecated-builtins` compiler flag being set.

These can be overridden using the `no` version, in this case `-Wno-deprecated-builtins`.

This can be done as follows:

```ruby
lane :development do
  build_app(
    xcargs: "OTHER_CFLAGS=""-Wno-deprecated-builtins""",
    scheme: "Runner",
    configuration: "Release")
end
```

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

Fastlane will by default stick build artefacts in the cwd.

Override this using the `output_directory` config element;

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
