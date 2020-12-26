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
6. [Screens & Responsivity](#screens--responsivity)
7. [Media](#media)
8. [Roadmap](#roadmap)

## Installation

In your project's `pubspec.yaml` add:
```yaml
dependencies:
  tch_appliable_core: ^0.0.1
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

*Coming soon...*

## Preferences

*Coming soon...*

## Screens & Responsivity

*Coming soon...*

## Media

*Coming soon...*

## Roadmap

*Coming soon...*
