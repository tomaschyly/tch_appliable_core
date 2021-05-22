import 'package:example/core/Router.dart' as AppRouter;
import 'package:example/model/SQLiteRecord.dart';
import 'package:example/ui/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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
      preferencesOptions: PreferencesOptions(),
      mainDataProviderOptions: MainDataProviderOptions(
        sqLiteOptions: SQLiteOptions(
          databasePath: () async => join((await getDatabasesPath()), 'default.db'),
          version: 1,
          onCreate: _dbInit,
        ),
        httpClientOptions: HTTPClientOptions(
          hostUrl: 'https://jsonplaceholder.typicode.com',
        ),
        sembastOptions: SembastOptions(
          databasePath: () async => join((await getDatabasesPath()), 'sembast.db'),
          version: 1,
        ),
      ),
    );
  }

  /// Initialize db tables
  Future<void> _dbInit(Database database, int version) async {
    await SQLiteRecord.createTable(database);
  }
}

class AppDataStateSnapshot extends AbstractAppDataStateSnapshot {}
