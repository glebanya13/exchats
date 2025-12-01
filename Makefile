clean:
	fvm flutter clean
	fvm flutter pub get

pods\:m1:
	cd ios && arch -x86_64 pod install

gen:
	fvm dart run build_runner build --delete-conflicting-outputs

gen\:watch:
	fvm dart run build_runner watch --delete-conflicting-outputs

gen\:clean:
	fvm dart run build_runner clean

env:
	fvm dart run environment_config:generate --config=env.yaml

env\:dev:
	fvm dart run environment_config:generate --config-extension=dev --config=env.yaml

env\:proxy:
	fvm dart run environment_config:generate --config-extension=proxy --config=env.yaml

env\:dev-proxy:
	fvm dart run environment_config:generate --config-extension=dev-proxy --config=env.yaml

gen\:locale:
	fvm dart run easy_localization:generate -S assets/lang -o locale_loader.g.dart
	fvm dart run easy_localization:generate -f keys -S assets/lang -o locale_keys.g.dart
