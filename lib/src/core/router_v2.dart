import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutingArgumentsV2 {
  final String? route;

  /// Have to use RoutingArgumentsV2.of(context) for this to work
  bool isCurrent = false;

  final Map<String, String>? _query;

  /// RoutingArgumentsV2 initialization
  RoutingArgumentsV2({
    this.route,
    Map<String, String>? query,
  }) : _query = query;

  /// RoutingArgumentsV2 from current GoRouterState
  static RoutingArgumentsV2? of(BuildContext context) {
    try {
      final state = GoRouterState.of(context);
      final modalRoute = ModalRoute.of(context);

      return RoutingArgumentsV2(
        route: state.uri.path,
        query: Map<String, String>.from(state.uri.queryParameters),
      )..isCurrent = modalRoute?.isCurrent ?? true;
    } catch (_) {
      return null;
    }
  }

  /// Using [] operator gets value from query for key
  String? operator [](String key) => _query?[key];
}

extension BuildContextRoutingV2Extension on BuildContext {
  /// Shorthand to get RoutingArgumentsV2 from context
  RoutingArgumentsV2? get routingArgumentsV2 => RoutingArgumentsV2.of(this);
}

/// Push named route to stack (go_router V2)
Future<T?> pushNamedV2<T>(BuildContext context, String routeName, {Map<String, String>? arguments}) {
  return context.pushNamed<T>(routeName, queryParameters: arguments ?? {});
}

/// Push named route to stack & clear all others (go_router V2)
void goNamedV2(BuildContext context, String routeName, {Map<String, String>? arguments}) {
  context.goNamed(routeName, queryParameters: arguments ?? {});
}

/// Pop the route if not yet disposed (go_router V2)
void popNotDisposedV2<T extends Object?>(BuildContext context, bool mounted, [T? result]) {
  if (mounted) {
    context.pop<T>(result);
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
            CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInOut),
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
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}
