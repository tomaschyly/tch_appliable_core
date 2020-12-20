import 'package:example/ui/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

/// Generate Route with Screen for RoutingArguments from Route name
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
