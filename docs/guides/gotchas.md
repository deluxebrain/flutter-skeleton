# Gotchas

## `pod` command

Reading through various Flutter support cases it appears that all pod management is supposed to be done through flutter. I.e:

> Never use the `pod` command directly

## Cocoapods error

I had issues whereby the latest stable release of cocoapods depended on a broken version of activesupport.

The fix was as follows:

```sh
    gem install cocoapods
    # https://stackoverflow.com/questions/77236339/after-updating-cocoapods-to-1-13-0-it-throws-error
    gem  uninstall --force activesupport
    gem install activesupport -v 7.0.8
    pod setup
```

## Bug with spaces in application name

The firebase cli does not support spaces in the application name.
This will lead to `flutterfire configure` generating nonsense build phase scripts when combined with flavors.

## Bug with iOS simulator deployment target

Once I added firebase with flavors and crashlytics I was getting [errors like those here](https://stackoverflow.com/questions/54704207/the-ios-simulator-deployment-targets-is-set-to-7-0-but-the-range-of-supported-d).

Based on that article the following changes to my `ios/Podfile` fixed the issue:

```ruby
# Uncomment this line to define a global platform for your project
platform :ios, '12.0'

# ...

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
    flutter_additional_ios_build_settings(target)
  end
end
```

## Xcode failing to build due to permission issues

Ref: [https://github.com/flutter/flutter/issues/128739]

- Runner --> Targets --> Build Settings --> Build Options --> User Script Sandboxing --> No

## Full project clean

```sh
flutter clean
rm pubspec.lock ios/Podfile.lock
rm -rf ios/Pods
rm -rf ios/Runner.xcworkspace # ? Not sure about this one
flutter pub get
flutter build
```
