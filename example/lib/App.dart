import 'package:example/core/Router.dart' as AppRouter;
import 'package:example/ui/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
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
      initializationMinDurationInMilliseconds: 1200,
      initialScreenRoute: HomeScreen.ROUTE,
      onGenerateRoute: AppRouter.onGenerateRoute,
      snapshot: AppDataStateSnapshot(),
      translatorOptions: TranslatorOptions(
        languages: ['en', 'sk'],
        supportedLocales: [const Locale('en'), const Locale('sk')],
      ),
    );
  }
}

class AppDataStateSnapshot extends AbstractAppDataStateSnapshot {}
