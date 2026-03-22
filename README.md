# tch_appliable_core

Flutter core package used by [Tomas Chyly](https://tomas-chyly.com/en/) & partners/clients. Contains common functionality to get started faster & consistently.
There are a number of useful utils for use in your projects.

This package includes example, in this example you should be able to see basic usage of features provided by this package.
If some instructions are not clear enough, then analyse usage inside the example.

**Platforms notice:** I have worked on projects that use Flutter on all platforms, but my focus is on **Mobile** and **Desktop**. Therefore some widgets and features may not work on **Web**, but should work on other platforms. Personally I do not consider Flutter ready for web dev.

**Development notice:** This documentation is out of date for lack of time, but the package itself continues to be maintained and developed over time.

## Contents

1. [Installation](#installation)
2. [App Create](#app-create)
3. [Router V1 (Navigator 1.0)](#router-v1-navigator-10)
4. [Router V2 (go_router)](#router-v2-go_router)
5. [Translator](#translator)
6. [Preferences](#preferences)
7. [Screens, Widgets & Responsivity](#screens-widgets--responsivity)
8. [MainDataProvider & DataWidgets](#maindataprovider--datawidgets)
9. [Hooks](#hooks)
10. [Media](#media)
11. [Utils](#utils)
12. [Roadmap](#roadmap)

## Installation

In your project's `pubspec.yaml` add:
```yaml
dependencies:
  tch_appliable_core: ^0.37.0+1
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

## Router V1 (Navigator 1.0)

V1 uses Flutter's built-in `Navigator`. Choose this over V2 if you do not need web deep linking or URL-based navigation. Pass a `RouteFactory` via `onGenerateRoute` to `CoreApp`. `initialScreenRoute` is the route path launched after app initialisation.

```dart
...
@override
Widget build(BuildContext context) {
  return CoreApp(
    ...
    initialScreenRoute: HomeScreen.kRoute,
    onGenerateRoute: AppRouter.onGenerateRoute,
    ...
  );
}
...
```

Create your route factory in `lib/core/app_router.dart`:

```dart
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final arguments = settings.name?.routingArguments;

  if (arguments != null) {
    switch (arguments.route) {
      case HomeScreen.kRoute:
        return createRoute((BuildContext context) => HomeScreen(), settings);
      default:
        throw Exception('Implement onGenerateRoute in app');
    }
  }

  throw Exception('Arguments not available');
}
```

Navigate using the provided functions — do not use `Navigator` directly:

```dart
Future<T?> pushNamed<T>(context, routeName, {Map<String, String>? arguments})
Future<T?> pushNamedNewStack<T>(context, routeName, {Map<String, String>? arguments})
void popNotDisposed<T>(context, mounted, [result])
```

Read route arguments in a screen via the `BuildContext` extension:

```dart
final args = context.routingArguments;
final id = args?['id'];
```

## Router V2 (go_router)

V2 uses the [`go_router`](https://pub.dev/packages/go_router) package. It works better on web (proper URL handling) and supports deep linking out of the box. Both V1 and V2 support named routes only.

Instead of `onGenerateRoute`, pass a `GoRouter` instance to `CoreApp`:

```dart
...
@override
Widget build(BuildContext context) {
  return CoreApp(
    ...
    initialScreenRoute: HomeScreen.kRoute,
    router: AppRouter.router,
    ...
  );
}
...
```

Create your router in `lib/core/app_router.dart`:

```dart
final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: HomeScreen.kRoute,
      path: HomeScreen.kRoute,
      pageBuilder: (context, state) => createGoPage(state, HomeScreen()),
    ),
    GoRoute(
      name: SettingsScreen.kRoute,
      path: SettingsScreen.kRoute,
      pageBuilder: (context, state) => createGoPage(state, SettingsScreen()),
    ),
  ],
);
```

Use `pageBuilder` with the provided helpers to match V1 transition behaviour:

```dart
createGoPage(state, child)            // standard platform animation
createGoPageFade(state, child)        // fade (equivalent of FadeAnimationPageRoute)
createGoPageNoAnimation(state, child) // no animation (equivalent of NoAnimationPageRoute)
```

Navigate using the V2 functions:

```dart
Future<T?> pushNamedV2<T>(context, routeName, {Map<String, String>? arguments})
void goNamedV2(context, routeName, {Map<String, String>? arguments})
void popNotDisposedV2(context, mounted, [result])
```

Read route arguments in a screen via the `BuildContext` extension:

```dart
final args = context.routingArgumentsV2;
final id = args?['id'];
```

## Translator

Translator is an optional feature of this package. You activate it by providing `TranslatorOptions` to the CoreApp.

Translator works well with my [JsTrions](https://github.com/tomaschyly/JsTrions) JSON translations app.

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
await Translator.instance!.changeLanguage('sk');
```

`changeLanguage` reloads the translations and notifies the locale change automatically — no additional call needed.

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

## Hooks

*Coming soon...*

## Media

*Coming soon...*

## Utils

This package includes a number of utils, methods and extensions. Check the code for useful features that you can use.

* Boundary
* Color
* List
* Numbers
* Text

## Roadmap

Until version 1.0.0 there will not be predictable roadmap. Instead development is dependant on requirements of projects where this package is used.
Core pillars of this package are however already implemented.
