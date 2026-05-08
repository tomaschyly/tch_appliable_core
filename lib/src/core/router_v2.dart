import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutingArgumentsV2 {
  final String? route;
  final String? fragment;

  /// Have to use RoutingArgumentsV2.of(context) for this to work
  bool isCurrent = false;

  final Map<String, String>? _query;
  final Map<String, String>? _pathParameters;

  /// RoutingArgumentsV2 initialization
  RoutingArgumentsV2({
    this.route,
    this.fragment,
    Map<String, String>? query,
    Map<String, String>? pathParameters,
  }) : _query = query,
       _pathParameters = pathParameters;

  /// RoutingArgumentsV2 from current GoRouterState
  static RoutingArgumentsV2? of(BuildContext context) {
    try {
      final state = GoRouterState.of(context);
      final modalRoute = ModalRoute.of(context);

      return RoutingArgumentsV2(
        route: state.uri.path,
        fragment: state.uri.fragment.isEmpty ? null : state.uri.fragment,
        query: Map<String, String>.from(state.uri.queryParameters),
        pathParameters: Map<String, String>.from(state.pathParameters),
      )..isCurrent = modalRoute?.isCurrent ?? true;
    } catch (_) {
      return null;
    }
  }

  /// Using [] operator gets value from query for key
  String? operator [](String key) => _query?[key];

  /// Get value from path parameters for key
  String? path(String key) => _pathParameters?[key];
}

extension BuildContextRoutingV2Extension on BuildContext {
  /// Shorthand to get RoutingArgumentsV2 from context
  RoutingArgumentsV2? get routingArgumentsV2 => RoutingArgumentsV2.of(this);
}

/// Push named route by route name and URL parameters (go_router V2)
Future<Object?> pushNamedV2(
  BuildContext context,
  String routeName, {
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, dynamic> queryParameters = const <String, dynamic>{},
  String? fragment,
}) {
  final location = context.namedLocation(
    routeName,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    fragment: fragment,
  );

  return context.push<Object?>(location);
}

/// Push named route by route name and URL parameters using navigator (go_router V2)
Future<Object?> pushNamedV2ByNavigator(
  NavigatorState navigator,
  String routeName, {
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, dynamic> queryParameters = const <String, dynamic>{},
  String? fragment,
}) {
  final location = navigator.context.namedLocation(
    routeName,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    fragment: fragment,
  );

  return navigator.context.push<Object?>(location);
}

/// Replace top route with a named route and URL parameters (go_router V2)
void pushReplacementNamedV2(
  BuildContext context,
  String routeName, {
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, dynamic> queryParameters = const <String, dynamic>{},
  String? fragment,
}) {
  final location = context.namedLocation(
    routeName,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    fragment: fragment,
  );

  context.pushReplacement(location);
}

/// Replace top route with a named route and URL parameters using navigator (go_router V2)
void pushReplacementNamedV2ByNavigator(
  NavigatorState navigator,
  String routeName, {
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, dynamic> queryParameters = const <String, dynamic>{},
  String? fragment,
}) {
  final location = navigator.context.namedLocation(
    routeName,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    fragment: fragment,
  );

  navigator.context.pushReplacement(location);
}

/// Navigate to a named route with URL parameters (go_router V2)
void goNamedV2(
  BuildContext context,
  String routeName, {
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, dynamic> queryParameters = const <String, dynamic>{},
  String? fragment,
}) {
  context.goNamed(
    routeName,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    fragment: fragment,
  );
}

/// Navigate to a named route with URL parameters using navigator (go_router V2)
void goNamedV2ByNavigator(
  NavigatorState navigator,
  String routeName, {
  Map<String, String> pathParameters = const <String, String>{},
  Map<String, dynamic> queryParameters = const <String, dynamic>{},
  String? fragment,
}) {
  navigator.context.goNamed(
    routeName,
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    fragment: fragment,
  );
}

/// Pop the route if not yet disposed (go_router V2)
void popNotDisposedV2(BuildContext context, bool mounted, [Object? result]) {
  if (mounted) {
    context.pop(result);
  }
}

/// Pop the route using navigator if not yet disposed (go_router V2)
void popNotDisposedV2ByNavigator(
  NavigatorState navigator,
  bool mounted, [
  Object? result,
]) {
  if (mounted) {
    navigator.pop(result);
  }
}

/// Create a standard page for go_router (equivalent of MaterialPageRoute in V1)
Page<T> createGoPage<T>(GoRouterState state, Widget child) {
  return MaterialPage<T>(key: state.pageKey, child: child);
}

/// Create a fade-animated page for go_router (equivalent of FadeAnimationPageRoute in V1)
Page<T> createGoPageFade<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        child: FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        ),
      );
    },
  );
}

/// Create a no-animation page for go_router (equivalent of NoAnimationPageRoute in V1)
Page<T> createGoPageNoAnimation<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        child,
  );
}
