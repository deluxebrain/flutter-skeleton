# Code notes

## Top-level app error handling

A top-level zone is used to handle all uncaught async exceptions:

```dart
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(...);

    registerErrorHandlers(...);

    runApp(UncontrolledProviderScope(...);
  }, (error, stack) {
    // log all uncaught async exceptions
    logError(...);
  });
```

The call to `runApp` must be run in same zone that the call to `ensureInitialized` is made.

Flutter and platform error handlers are wired up by the call to `registerErrorHandlers`. This must be done _after_ both Flutter and Firebase are initialized.
