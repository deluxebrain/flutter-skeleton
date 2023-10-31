install:
	asdf local ruby latest:3

	# install cocoapods and fixup activesupport version
	gem install cocoapods
	https://stackoverflow.com/questions/77236339/after-updating-cocoapods-to-1-13-0-it-throws-error
	gem uninstall --force activesupport
	gem install activesupport -v 7.0.8

	asdf local java latest:temurin

	asdf local flutter latest
	asdf local firebase latest
	dart pub global activate flutterfire_cli

	flutter pub get
	flutter doctor -v

lint:
	dart run custom_lint

gen:
	flutter pub run build_runner watch --delete-conflicting-outputs

l10n:
	flutter gen-l10n

assets:
	flutter pub run flutter_launcher_icons
	dart run flutter_native_splash:create --flavors dev,stg,prod
