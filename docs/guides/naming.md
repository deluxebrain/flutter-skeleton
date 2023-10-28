# Naming conventions

## Flutter project

Flutter project names must adhere to [Dart package naming conventions](https://dart.dev/tools/linter-rules/package_names#:~:text=Package%20names%20should%20be%20all,isn%27t%20a%20reserved%20word.) and only contain the following characters: `[a-z0-9_].

E.g: `my_app`

[Apple bundle identifiers](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier#) must contain only the following characters: (`[A-Za-z0-9-]`.

E.g: com.example.my-app

Android application ids must adhere to [Java package naming conventions](https://docs.oracle.com/javase/tutorial/java/package/namingpkgs.html#:~:text=Naming%20Conventions,a%20programmer%20at%20example.com%20.) and contain only the following characters: (`[a-z0-9_]`).

E.g: com.example.my_app

The bundle and app ids are defaulted based in the flutter project name.

Bundle id:

- spaces --> -
- \_ --> camelCase ( e.g. my_app --> myApp )

Application id:

- same naming convention

> In order to make the bundle and app ids the same, and because the bundle and app ids have opposite support for \_ and -, I use a strict naming convention of [a-z0-9] for the flutter project name.

E.g.

Flutter project: myapp
Bundle id: com.example.myapp
Application id: com.example.myapp

> Flavors then use a further dot separate suffix.

E.g.
com.example.myapp.dev

> As all lowercase does not work very well as the name of the project directory, I use [a-z-] and allow for the directory name to be different to the flutter project name.
