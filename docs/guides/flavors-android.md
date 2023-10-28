# Adding flavors to Android app

## Add flavors to `build.gradle`

Update file `android\app\build.gradle` to specify each flavor:

```gradle
    flavorDimensions "default"

    productFlavors {
        production {
            dimension "default"
            applicationIdSuffix ""
            manifestPlaceholders = [appName: "App"]
        }
        development {
            dimension "default"
            applicationIdSuffix ".dev"
            manifestPlaceholders = [appName: "[DEV] App"]
        }
    }
```
