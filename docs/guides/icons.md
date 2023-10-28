# App icons

## Icon creation

Create in Figma. For best fidelity generate each required icon size as an svg file and export as png.

Alternatively create a single 1024x1024 icon as a png and generate each required icon size from it.

iOS ( via universal icons ) and Android ( via adaptive icons ) both now support auto-generation of all icon sizes from a single png.

Figma templates exist to help with the creation of the icons. [This template](https://www.figma.com/community/file/1155362909441341285) generates both the ios and android icons and has a [tutorial](https://www.youtube.com/watch?v=QSNkU7v0MPc).

[Icons8](https://icons8.com/app/figma) is a resource of icons etc that can be used to create app icons from. However, at its free tier only small png exports are allowed.

## Integration of app launcher icons with flavors

Two approaches are given. The first a simplified workflow using a third-party flutter package. The second done manually.

### Via flutter_launcher_icons package

This approach appears to generate all required icon sizes from your single seed icon files. I.e. it does NOT use iOS universal icons nor Android adaptive icons.

Set up project as follows:

```text
assets/launcher_icon/
  - {icon per flavor}
  - e.g. icon-dev.png
flutter_launcher_icons-{flavor}
e.g. flutter_launcher_icons-development.yaml
```

Populate the `flutter_launcher_icons_{flavor}.yaml` file.
E.g:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  remove_alpha_ios: true
  image_path: "assets/images/demo-icon.png"
```

Generate icons:

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

Update the xcode build settings to use the correct icon set:

- Runner --> Targets --> Runner --> Build Settings --> Primary App Icon Set Name: AppIcon-{flavor}

For some reason you also need to delete the original default icon set or flutter build complains that the app uses the default icons:

- ios/Runner/Assets/xcassets/AppIcon.appiconset

### Manually

#### iOS via a single univeral icon

Adding icon assets:

- Open project in xcode
- Side menu: Runner --> Runner --> Assets.xcassets
- "+" --> iOS --> iOS App Icon
- Name it AppIcon-{flavor}, e.g. AppIcon-development
- RHS side menu: App Icon --> iOS --> Single Size
- Drag in your 1024x1024 app icon

Configuring per-flavor app icon:

- Runner --> Targets --> Runner --> Build Settings
- Primary App Icon Set Name:
  - {build configuration}: {Icon set}
  - e.g. Debug-development: AppIcon-development

#### Android via adaptive icon

TODO - cant find much documentation around how todo this!
