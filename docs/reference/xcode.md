# Xcode project review

## Pre-flavors

```text
Runner/
  Flutter/
    AppFrameworkInfo.plist
    Debug.xcconfig
    Release.xcconfig
    Generated.xcconfig
  Runner/
  Products/
    Runner.app ( red )
    RunnerTests.xctest ( red )
  RunnerTests/
  Pods/
    Pods-Runner.debug.xcconfig
    Pods-Runner.release.xcconfig
    Pods-Runner.profile.xcconfig
    Pods-RunnerTests.debug.xcconfig
    Pods-RunnerTests.release.xcconfig
    Pods-RunnerTests.profile.xcconfig
  Frameworks/
    Pods_Runner.framework (red )
    Pods_RunnerTests.framework ( red )
```

## Post-flavors

```text
Runner/
  Flutter/
    AppFrameworkInfo.plist
    Debug.xcconfig
    Release.xcconfig
    Generated.xcconfig
    common.xcconfig
    dev.xcconfig
    stg.xcconfig
    prod.xcconfig
  Runner/
  Products/
    Runner.app ( red )
    RunnerTests.xctest ( red )
  RunnerTests/
  Pods/
    Pods-Runner.debug-prod.xcconfig
    Pods-Runner.debug-stg.xcconfig
    Pods-Runner.debug-dev.xcconfig
    Pods-Runner.release-prod.xcconfig
    Pods-Runner.release-stg.xcconfig
    Pods-Runner.release-dev.xcconfig
    Pods-Runner.profile-prod.xcconfig
    Pods-Runner.profile-stg.xcconfig
    Pods-Runner.profile-dev.xcconfig
    Pods-RunnerTests.debug-prod.xcconfig
    Pods-RunnerTests.debug-stg.xcconfig
    Pods-RunnerTests.debug-dev.xcconfig
    Pods-RunnerTests.release-prod.xcconfig
    Pods-RunnerTests.release-stg.xcconfig
    Pods-RunnerTests.release-dev.xcconfig
    Pods-RunnerTests.profile-prod.xcconfig
    Pods-RunnerTests.profile-stg.xcconfig
    Pods-RunnerTests.profile-dev.xcconfig
  Frameworks/
    Pods_Runner.framework (red )
    Pods_RunnerTests.framework ( red )
```

Build phases:

```text
Target Dependencies ( 0 items )
Run Build Tool Plug-ins ( 0 items )
[CP] Check Pods Manifest.lock
Run Script
  /bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
Compile Sources ( 2 items )
Link Binaries With Libraries ( 1 item )
Copy Bundle Resources ( 8 items )
  - dev.xcconfig
  - prod.xcconfig
  - LaunchScreen.storyboard
  - AppFrameworkInfo.plist
  - Assets.xcassets
  - stg.xcconfig
  - Main.storyboard
  - common.xcconfig
Embed Frameworks ( 0 items )
Thin Binary
FlutterFire: "flutterfire bundle-service-file"
FlutterFire: "flutterfire upload-crashlytics-symbols"
[CP] Embed Pods Frameworks
  "${PODS_ROOT}/Target Support Files/Pods-Runner/Pods-Runner-frameworks.sh"
```
