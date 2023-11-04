# Devices

## Running locally

- Xcode:

  - Connect device
  - Accept the trust request on the device

- Device:

  - System --> Privacy & Security --> Enable developmer mode
  - Reboot

- Xcode
  - Runner --> Targets --> Runner
    - Signing & Capabilities
      - Add device to each signing profile
  - Window --> Devices and Simulators
    - Verify device

List devices:

```sh
flutter devices
```

NOTE that debug builds of the app can only be launched from flutter.
I.e: if you run a debug build via `flutter run` and then quit out of it, the app will crash if launched directly from the phone. Release builds work ok.
