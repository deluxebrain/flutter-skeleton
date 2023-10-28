# Adding flavors to iOS app

## Terminology

A `bundle identifier` uniquely identifies an application within the Apple or Android ecosystem.

A `project` in xcode has one or more `targets`.

A `project` has a set of `build configurations`. By default these are `Debug`, `Release` and `Profile`.

`Build configurations` are based on `configuration files` ( .xcconfig files ). By default these are `Debug.xcconfig` and `Release.xcconfig`.

A `target` represents a `product` within the `project` and defines a corresponding set of build settings.

A `project` has one or more `schemes` that map to build actions, such as `Build`, `Run`, `Test`, etc. These build actions are peformed against a specific `build configuration`.

## iOS flavors

Flavors are an Andoid technology and have no direct single abstraction in iOS.

Howevers, it is possible to recreate flavors in ios using existing xcode abstrations.

This is done as follows:

- Create build configuration file per flavor
- Create build configuration sets ( debug, release, profile ) across each flavor
- Create scheme per flavor
- Configure each scheme action to use the corresponding build configuration for that flavor for that action.
- Configure the bundle identifier for each set of build configurations per flavor to be unique

So, depending on how you look at it, if you want to consider a single xcode abstraction the _flavor_ then it is either:

- build configurations, as bundle identifiers are controlled per target per build configuration and build identifiers uniquely identify a flavor of deployed application
- or schemes, as there is a one-to-one mapping between flavors and schemes

## Create common configurations settings file

Used to store common configuration across all flavors.
Im using `X_` as a prefix to separate out my custom configuration.

Within xcode:

- Runner --> right click --> New File --> Configuration Settings File
  Name as: common.xcconfig
  Save to ios/Flutter
  Group: Runner
  Targets: Runner

## Create configurations settings file per flavor

Used to store flavor specific configuration.

Used to store common configuration across all flavors.
Im using `X_` as a prefix to separate out my custom configuration.

Within xcode:

- Runner --> right click --> New File --> Configuration Settings File
  Name as: {flavor}.xcconfig ( e.g. development.xcconfig )
  Save to ios/Flutter
  Group: Runner
  Targets: Runner

## Info.plist

Within xcode:

- Bundle display name: {blank}
  Clear bundle display name as we require this set per flavor.
  Setting this here as a default appears to override the value for all flavors.
- Bundle name: $(X_BUNDLE_NAME)
  Note its not possible to set this at the build configuration level

Note that values in the plist are per app not per project.

## Create build configurations

Build configurations are what Flutter calls flavors.

Create build configuration per build target per desired environment ( development, production, free, etc).
Each build configuration should be pointed at the corresponding configuration file created above ( e.g. `development` )

Within xcode:

- Runner --> Project --> Runner --> Info --> Configurations
  - Debug-development
    - Runner: development
  - Debug-production (renamed original)
    - Runner: production
  - Release-development
    - Runner: development
  - Release-production (renamed original)
    - Runner: production
  - Profile-development
    - Runner: development
  - Profile-production (renamed original)
    - Runner: production

## Add build configurations to Podfile

Within vscode:

Update file `ios\Podfile` to include the new build configurations:

```ruby
project 'Runner', {
  'Debug-development' => :debug,
  'Debug-production' => :release,
  'Profile-development' => :release,
  'Profile-production' => :release,
  'Release-development' => :release,
  'Release-production' => :release,
}
```

## Create scheme per flavor

Create scheme per flavor, ensure to name it the same as the flavor.
Once the schemes are created, go back and edit them so each build action uses the correct build configuration. Note this I tend to leave the existing Flutter `Runner` schema alone and create new schemes.

Within xcode:

- development
- production
  Update each action within each schema to use the correct build configuration
  Run --> Debug-
  Test --> Debug-
  Profile --> Profile-
  Analyze --> Debug-
  Archive --> Release-

## Mapping flavors to apps

Build configuration map to flavors. So with the 6 build configurations added above we have 6 flavors.

Any of those flavors can be deployed, however as it stands each deployment will overright any previous deployment.

To allow for side-by-side deployments of flavors we need to create a unique bundle identifier per flavor of interest.

Within xcode:

- Runner --> Targets --> Runner --> Build Settings
  Product Bundle Identifier: $(X_FLAVOR_BUNDLE_ID)

## Target build settings

Within xcode:

- Runner --> Targets --> Runner --> Build Settings
  - Bundle Display Name: `$(X_FLAVOR_BUNDLE_DISPLAY_NAME)`
  - Product Name: `$(X_FLAVOR_APP_NAME)`
  - Primary App Icon Set Name: `$(X_FLAVOR_APP_ICON)`

Product Name is used by the device as the app name associated with the launch icon.
