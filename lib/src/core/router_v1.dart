import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tch_appliable_core/src/core/router/boundary_page_route.dart';
import 'package:tch_appliable_core/src/core/router/fade_animation_page_route.dart';
import 'package:tch_appliable_core/src/core/router/no_animation_page_route.dart';
import 'package:tch_appliable_core/utils/boundary.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// Generate Route with Screen for RoutingArguments from Route name
Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final arguments = settings.name?.routingArguments;

  if (arguments != null) {
    switch (arguments.route) {
      //    case ExampleScreen.ROUTE:
      //      return createRoute((BuildContext context) => ExampleScreen(), settings);
      default:
        throw Exception('Implement OnGenerateRoute in app');
    }
  }

  throw Exception('Arguments not available');
}

/// Create Route depending on platform for different effects
Route<T> createRoute<T extends Object>(
  WidgetBuilder builder,
  RouteSettings settings,
) {
  if (kIsWeb) {
    return NoAnimationPageRoute<T>(builder: builder, settings: settings);
  } else {
    final arguments = settings.name?.routingArguments;

    if (arguments != null && Boundary.validateRoutingJson(arguments)) {
      return BoundaryPageRoute<T>(
        builder: builder,
        boundary: Boundary.fromRoutingJson(arguments),
        settings: settings,
        borderRadius: arguments['router-boundary-radius']?.toDouble(),
      );
    } else if (arguments?['router-no-animation'] != null) {
      return NoAnimationPageRoute<T>(builder: builder, settings: settings);
    } else if (arguments?['router-fade-animation'] != null) {
      return FadeAnimationPageRoute<T>(builder: builder, settings: settings);
    } else {
      return MaterialPageRoute<T>(builder: builder, settings: settings);
    }
  }
}

class RoutingArguments {
  final String? route;

  /// Have to use RoutingArguments.of(context) for this to work
  bool isCurrent = false;

  final Map<String, String>? _query;

  /// RoutingArguments initialization
  RoutingArguments({this.route, Map<String, String>? query}) : _query = query;

  /// RoutingArguments from current ModalRoute
  static RoutingArguments? of(BuildContext context) {
    final route = ModalRoute.of(context);

    return route?.settings.name?.routingArguments
      ?..isCurrent = route?.isCurrent ?? false;
  }

  /// Using [] operator gets value from query for key
  String? operator [](String key) => _query?[key];
}

extension BuildContextRoutingExtension on BuildContext {
  /// Shorthand to get RoutingArguments from context
  RoutingArguments? get routingArguments => RoutingArguments.of(this);
}

extension StringExtension on String {
  /// Convert String into RoutingArguments
  RoutingArguments? get routingArguments {
    if (isEmpty) {
      return null;
    }

    final uri = Uri.parse(this);

    return RoutingArguments(route: uri.path, query: uri.queryParameters);
  }
}

/// Push named route to stack
Future<T?> pushNamed<T extends Object?>(
  BuildContext context,
  String routeName, {
  Map<String, String>? arguments,
}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return Navigator.pushNamed<T>(context, routeName);
}

/// Push named route to stack using navigator
Future<T?> pushNamedByNavigator<T extends Object?>(
  NavigatorState navigator,
  String routeName, {
  Map<String, String>? arguments,
}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return navigator.pushNamed<T>(routeName);
}

/// Push replacement named route to stack
Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
  BuildContext context,
  String routeName, {
  Map<String, String>? arguments,
  TO? result,
}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return Navigator.pushReplacementNamed<T, TO>(
    context,
    routeName,
    result: result,
  );
}

/// Push replacement named route to stack using navigator
Future<T?>
pushReplacementNamedByNavigator<T extends Object?, TO extends Object?>(
  NavigatorState navigator,
  String routeName, {
  Map<String, String>? arguments,
  TO? result,
}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return navigator.pushReplacementNamed<T, TO>(routeName, result: result);
}

/// Push named route to stack & clear all others
Future<T?> pushNamedNewStack<T extends Object?>(
  BuildContext context,
  String routeName, {
  Map<String, String>? arguments,
  RoutePredicate? predicate,
}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return Navigator.pushNamedAndRemoveUntil<T>(
    context,
    routeName,
    predicate ?? (Route<dynamic> route) => false,
  );
}

/// Push named route to stack & clear all others using navigator
Future<T?> pushNamedNewStackByNavigator<T extends Object?>(
  NavigatorState navigator,
  String routeName, {
  Map<String, String>? arguments,
  RoutePredicate? predicate,
}) {
  if (arguments != null) {
    routeName = Uri(path: routeName, queryParameters: arguments).toString();
  }

  return navigator.pushNamedAndRemoveUntil<T>(
    routeName,
    predicate ?? (Route<dynamic> route) => false,
  );
}

/// Pop the route if not yet disposed
void popNotDisposed<T extends Object?>(
  BuildContext context,
  bool mounted, [
  T? result,
]) {
  if (mounted) {
    Navigator.pop<T>(context, result);
  }
}

/// Pop the route using navigator if not yet disposed
void popNotDisposedByNavigator<T extends Object?>(
  NavigatorState navigator,
  bool mounted, [
  T? result,
]) {
  if (mounted) {
    navigator.pop<T>(result);
  }
}
