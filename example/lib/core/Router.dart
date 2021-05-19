import 'package:example/ui/screens/HomeScreen.dart';
import 'package:example/ui/screens/mdpHttp/MDPHttpScreen.dart';
import 'package:example/ui/screens/mdpSQLite/MDPSQLiteRecordScreen.dart';
import 'package:example/ui/screens/mdpSQLite/MDPSQLiteScreen.dart';
import 'package:example/ui/screens/mdpSembast/MDPSembastRecordScreen.dart';
import 'package:example/ui/screens/mdpSembast/MDPSembastScreen.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

/// Generate Route with Screen for RoutingArguments from Route name
Route<Object> onGenerateRoute(RouteSettings settings) {
  final arguments = settings.name?.routingArguments;

  if (arguments != null) {
    switch (arguments.route) {
      case HomeScreen.ROUTE:
        return createRoute((BuildContext context) => HomeScreen(), settings);
      case MDPSQLiteScreen.ROUTE:
        return createRoute((BuildContext context) => MDPSQLiteScreen(), settings);
      case MDPSQLiteRecordScreen.ROUTE:
        return createRoute((BuildContext context) => MDPSQLiteRecordScreen(), settings);
      case MDPHttpScreen.ROUTE:
        return createRoute((BuildContext context) => MDPHttpScreen(), settings);
      case MDPSembastScreen.ROUTE:
        return createRoute((BuildContext context) => MDPSembastScreen(), settings);
      case MDPSembastRecordScreen.ROUTE:
        return createRoute((BuildContext context) => MDPSembastRecordScreen(), settings);
      default:
        throw Exception('Implement OnGenerateRoute in app');
    }
  }

  throw Exception('Arguments not available');
}
