import 'package:example/ui/screens/home_screen.dart';
import 'package:example/ui/screens/mdpHttp/mdp_http_screen.dart';
import 'package:example/ui/screens/mdpMockup/mdp_mockup_screen.dart';
import 'package:example/ui/screens/mdpMockup/mdp_mockup_task_screen.dart';
import 'package:example/ui/screens/mdpSQLite/mdp_sqlite_record_screen.dart';
import 'package:example/ui/screens/mdpSQLite/mdp_sqlite_screen.dart';
import 'package:example/ui/screens/mdpSembast/mdp_sembast_record_screen.dart';
import 'package:example/ui/screens/mdpSembast/mdp_sembast_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

final GoRouter router = GoRouter(
  initialLocation: HomeScreen.route,
  routes: [
    GoRoute(
      name: HomeScreen.route,
      path: HomeScreen.route,
      pageBuilder: (context, state) => createGoPageFade(state, HomeScreen()),
    ),
    GoRoute(
      name: MDPSQLiteScreen.route,
      path: MDPSQLiteScreen.route,
      pageBuilder: (context, state) => createGoPageFade(state, MDPSQLiteScreen()),
    ),
    GoRoute(
      name: MDPSQLiteRecordScreen.route,
      path: MDPSQLiteRecordScreen.route,
      pageBuilder: (context, state) => createGoPage(state, MDPSQLiteRecordScreen()),
    ),
    GoRoute(
      name: MDPHttpScreen.route,
      path: MDPHttpScreen.route,
      pageBuilder: (context, state) => createGoPageFade(state, MDPHttpScreen()),
    ),
    GoRoute(
      name: MDPSembastScreen.route,
      path: MDPSembastScreen.route,
      pageBuilder: (context, state) => createGoPageFade(state, MDPSembastScreen()),
    ),
    GoRoute(
      name: MDPSembastRecordScreen.route,
      path: MDPSembastRecordScreen.route,
      pageBuilder: (context, state) => createGoPage(state, MDPSembastRecordScreen()),
    ),
    GoRoute(
      name: MDPMockupScreen.route,
      path: MDPMockupScreen.route,
      pageBuilder: (context, state) => createGoPageFade(state, MDPMockupScreen()),
    ),
    GoRoute(
      name: MDPMockupTaskScreen.route,
      path: MDPMockupTaskScreen.route,
      pageBuilder: (context, state) => createGoPage(state, MDPMockupTaskScreen()),
    ),
  ],
);
