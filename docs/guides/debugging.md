# Debugging

## Tracking compiler warnings/errors to dependencies

For example, how to track down the dependency that leads to this compiler warning:

```sh
[15:19:57]: ▸ ⚠️  /Users/deluxebrain/Library/Developer/Xcode/DerivedData/Runner-gzrfilvdjgmhdzgxofaluqqacrfw/Build/Intermediates.noindex/ArchiveIntermediates/Runner/BuildProductsPath/Release-iphoneos/abseil/absl.framework/Headers/meta/type_traits.h:494:17: builtin __has_trivial_assign is deprecated; use __is_trivially_assignable instead [-Wdeprecated-builtins]
[15:19:57]: ▸           bool, __has_trivial_assign(typename std::remove_reference<T>::type) &&
```

The offending library appears to be `abseil`. So we need to:

- verify that the project is infact using abseil
- workout what package has brought in the abseil dependency

Given this is the ios build, all dependencies will be managed using pods.

Hence, open `ios/Podfile.lock`

```txt
PODS:
  - abseil/algorithm (1.20220623.0):
    - abseil/algorithm/algorithm (= 1.20220623.0)
    - abseil/algorithm/container (= 1.20220623.0)
  - abseil/algorithm/algor
```

This verifies abseil is being brough in.

To work out by what, search for abseil references as follows: `    - abseil` ( 4 spaces):

```txt
  - FirebaseFirestore (10.16.0):
    - abseil/algorithm (~> 1.20220623.0)
```

I.e. the `Firestore` package is bringing in the `abseil` dependency.

To verify:

pubspec.yaml

```yaml
dependencies:
  cloud_firestore: ^4.12.2
```
