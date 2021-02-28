# tch_appliable_core

Flutter core package used by [Tomas Chyly](https://tomas-chyly.com/en/) & [appliable.eu](https://appliable.eu/). Contains common functionality to get started faster & consistently.

This package includes example, in this example you should be able to see basic usage of features provided by this package.
If some instructions are not clear enough, then analyse usage inside the example.

## Contents

1. [Installation](#installation)
2. [App Create](#app-create)
3. [Router (Navigator 1.0)](#router-navigator-10)
4. [Translator](#translator)
5. [Preferences](#preferences)
6. [Screens, Widgets & Responsivity](#screens-widgets--responsivity)
7. [MainDataProvider & DataWidgets](#maindataprovider--datawidgets)
8. [Media](#media)
9. [Roadmap](#roadmap)

## Installation

In your project's `pubspec.yaml` add:
```yaml
dependencies:
  tch_appliable_core: ^0.1.0-dev.12
```

## App Create

If your IDE does not autoImport, add manually:

```dart
import 'package:tch_appliable_core/tch_appliable_core.dart';
```

Then instead of using MaterialApp use CoreApp for you main app widget, which you run from your main.dart using runApp(App()).

```dart
...
@override
Widget build(BuildContext context) {
  return CoreApp(
    title: 'Core Example',
    initializationUi: Container(
      child: Center(
        child: Text(
          'This can be the same as splash\nor\ndifferent custom initialization UI',
          textAlign: TextAlign.center,
        ),
      ),
    ),
    initialScreenRoute: HomeScreen.ROUTE,
    onGenerateRoute: AppRouter.onGenerateRoute,
    snapshot: AppDataStateSnapshot(),
  );
}
...
```

Now your app will run as MaterialApp, but with included features from this package.

## Router (Navigator 1.0)

Currently usage of this router is required by CoreApp. To use it you need to provide `RouteFactory onGenerateRoute` to CoreApp.
`initialScreenRoute` is route name to be launched as initial screen of your app.

```dart
...
@override
Widget build(BuildContext context) {
  return CoreApp(
    ...
    initialScreenRoute: HomeScreen.ROUTE,
    onGenerateRoute: AppRouter.onGenerateRoute,
    ...
  );
}
...
```

To create your own RouteFactory, create new lib/core/Router.dart or use other place that you see fit. Then create the generator which you reference to the CoreApp.

```dart
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final arguments = settings.name?.routingArguments;

  if (arguments != null) {
    switch (arguments.route) {
      case HomeScreen.ROUTE:
        return createRoute((BuildContext context) => HomeScreen(), settings);
      default:
        throw Exception('Implement OnGenerateRoute in app');
    }
  }

  throw Exception('Arguments not available');
}
```

Then to navigate around your app, do not use `Navigator`, but instead functions provided by this package.

```dart
Future<T?> pushNamed<T extends Object>(BuildContext context, String routeName, {Map<String, String>? arguments})

Future<T?> pushNamedNewStack<T extends Object>

void popNotDisposed<T extends Object?>(BuildContext context, bool mounted, [T? result])
```

To transfer parameters between screens, use `RoutingArguments`.

*RoutingArguments info coming soon...*

## Translator

Translator is an optional feature of this package. You activate it by providing `TranslatorOptions` to the CoreApp.

```dart
...
@override
Widget build(BuildContext context) {
  return CoreApp(
    ...
    translatorOptions: TranslatorOptions(
      languages: ['en', 'sk'],
      supportedLocales: [const Locale('en'), const Locale('sk')],
    ),
    ...
  );
}
...
```

Then you need to add json transaction files into your assets with path `assets/translations/<code>.json` e.g. `assets/translations/en.json`.

The Translator uses your OS language automatically & if it is part of supportedLocales.
You can also change language during runtime.

```dart
Translator.instance?.changeLanguage('sk');
```

Then to see your new language immediately you can invalidate CoreApp.

```dart
CoreAppState.instance.invalidateApp();
``` 

To use the Translator for string translations, you just write text with short `tt` function.

```dart
tt('home.screen.title');
```

## Preferences

*Coming soon...*

## Screens, Widgets & Responsivity

All your `stateful` screens/widgets have to extend CoreApp abstract classes instead of Flutter.
See the example for resposive app implementation.

### Screens

First you should decide if you want to support resposivity or not. Then it is a good idea to create your app's main `AbstractAppScreen` & `AbstractAppScreenState` where you will be then able to setup defaults for your app.

It is better to support resposivity, for this your app's AbstractAppScreen extends `AbstractResposiveScreen` & AbstractAppScreenState extends `AbstractResposiveScreenState`.
CoreApp's responsity is divided into several screen sizes inspired by Bootstrap used on the web.

For non resposive screens/apps you extend `AbstractScreen` & `AbstractScreenState`.

CoreApp screens currently support creation of `AppBar`, `Drawer` and `BottomBar`. Check the example for details.

### Widgets

Just like screens, widgets can be resposive too extending `AbstractResponsiveWidget` & `AbstractResponsiveWidgetState`.

Or non resposive extending `AbstractStatefulWidget` & `AbstractStatefulWidgetState`.

### Useful methods

The reason for using CoreApp abstract classes are some useful methods that you should use.

E.g. you should not use `setState` but instead always use `setStateNotDisposed`.

Use `firstBuildOnly` for initialization on first build with BuildContext available.

## MainDataProvider & DataWidgets

*Coming soon...*

## Media

*Coming soon...*

## Roadmap

*Coming soon...*
