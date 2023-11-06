# FAQ

## Upgrading flutter version

```sh
asdf install flutter latest
asdf local flutter latest
flutter upgrade

# optionally upgrade all packages to latest version
flutter pub upgrade
```

## Controlling displayed application name

### iOS

Controlled through Build Settings --> Packaging --> Product Name
Also controls the filename off the associated `.app` file.

## Working out what a tool does to your project

Quite a lot of complexity can be hidden by the CLI of a tool.

E.g. the `flutterfire configure` command when used with flavors and crashlytics performs a lot of background manipulation of your project to support e.g. dSYM uploading, etc.

The following command will show recent file changes, and can help with debugging the changes a tool makes:

```sh
# list all files changed in the last 5 minutes
find . -mmin -5 -type f -exec ls -l {} +
```

## Looking up bundle ids within code

### ios

Runner --> Targets --> Runner --> Build Settings
Product Bundle Identifier: $(X_FLAVOR_BUNDLE_ID)

e.g:

- com.example.app
- com.example.app.dev

### Android

android/app/build.gradle
::applicationId
::applicationIdSuffix

## Finding bundle id of app in app store

- Connect iPhone to mac
- Open `Console` app on mac
- Select the iPhone within the devices list in console
- Open app on iPhone
- Search for the app name
- Search the filtered log messages for the bundle id
