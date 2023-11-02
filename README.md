# FLUTTER-SKELETON

## Documentation

Additional documentation available in the [docs](./docs/) directory.

This includes:

- A full [walkthrough of creating a new flutter project](./docs/tutorials/walkthrough.md)
- Full [guides of all included technology](./docs/guides/)

## Running this repo

### Flutter setup

Once you have cloned this repo you will need to setup your Flutter environment locally.

The target `install` in the makefile can be used to perform these steps:

```sh
make install
```

### Firebase configuration

Configure firebase according to [these instructions](./docs/firebase-crashlytics.md#configuring-firebase-and-crashlytics-with-flavors).

The helper script `./scripts/configure-firebase` can be used to perform these steps.

E.g:

```sh
./scripts/configure-firebase "my-project-id" "my-flavor" "my-bundle-id"
```

## Thanks to

- The wonderful [Flutter starter architecture](https://github.com/bizz84/starter_architecture_flutter_firebase/tree/master) repo:

  This formed the inspiration for the navigation and adaptive scaffold, as well as the basis for many of the `common_widgets`.

## Roadmap

- [] Replace Android launch icons with adaptive icon
- [] Work out how to have APP_NAME with spaces in it
- [] Support for deep linking, with and without auth
- [] Notifications
