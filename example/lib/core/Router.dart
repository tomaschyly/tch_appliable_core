import 'package:example/ui/screens/HomeScreen.dart';
import 'package:example/ui/screens/mdpHttp/MDPHttpScreen.dart';
import 'package:example/ui/screens/mdpMockup/MDPMockupScreen.dart';
import 'package:example/ui/screens/mdpMockup/MDPMockupTaskScreen.dart';
import 'package:example/ui/screens/mdpSQLite/MDPSQLiteRecordScreen.dart';
import 'package:example/ui/screens/mdpSQLite/MDPSQLiteScreen.dart';
import 'package:example/ui/screens/mdpSembast/MDPSembastRecordScreen.dart';
import 'package:example/ui/screens/mdpSembast/MDPSembastScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

final GoRouter router = GoRouter(
  initialLocation: HomeScreen.ROUTE,
  routes: [
    GoRoute(
      name: HomeScreen.ROUTE,
      path: HomeScreen.ROUTE,
      pageBuilder: (context, state) => createGoPageFade(state, HomeScreen()),
    ),
    GoRoute(
      name: MDPSQLiteScreen.ROUTE,
      path: MDPSQLiteScreen.ROUTE,
      pageBuilder: (context, state) => createGoPageFade(state, MDPSQLiteScreen()),
    ),
    GoRoute(
      name: MDPSQLiteRecordScreen.ROUTE,
      path: MDPSQLiteRecordScreen.ROUTE,
      pageBuilder: (context, state) => createGoPage(state, MDPSQLiteRecordScreen()),
    ),
    GoRoute(
      name: MDPHttpScreen.ROUTE,
      path: MDPHttpScreen.ROUTE,
      pageBuilder: (context, state) => createGoPageFade(state, MDPHttpScreen()),
    ),
    GoRoute(
      name: MDPSembastScreen.ROUTE,
      path: MDPSembastScreen.ROUTE,
      pageBuilder: (context, state) => createGoPageFade(state, MDPSembastScreen()),
    ),
    GoRoute(
      name: MDPSembastRecordScreen.ROUTE,
      path: MDPSembastRecordScreen.ROUTE,
      pageBuilder: (context, state) => createGoPage(state, MDPSembastRecordScreen()),
    ),
    GoRoute(
      name: MDPMockupScreen.ROUTE,
      path: MDPMockupScreen.ROUTE,
      pageBuilder: (context, state) => createGoPageFade(state, MDPMockupScreen()),
    ),
    GoRoute(
      name: MDPMockupTaskScreen.ROUTE,
      path: MDPMockupTaskScreen.ROUTE,
      pageBuilder: (context, state) => createGoPage(state, MDPMockupTaskScreen()),
    ),
  ],
);
