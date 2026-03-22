import 'package:example/core/Router.dart' as app_router;
import 'package:example/model/SQLiteRecord.dart';
import 'package:example/ui/screens/HomeScreen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CoreApp(
      title: 'Core Example',
      initializationUi: const Center(
        child: Text(
          'This can be the same as splash\nor\ndifferent custom initialization UI',
          textAlign: TextAlign.center,
        ),
      ),
      initializationMinDurationInMilliseconds: 1200,
      initialScreenRoute: HomeScreen.ROUTE,
      router: app_router.router,
      snapshot: AppDataStateSnapshot(),
      translatorOptions: TranslatorOptions(
        languages: ['en', 'sk'],
        supportedLocales: [const Locale('en'), const Locale('sk')],
      ),
      preferencesOptions: PreferencesOptions(),
      mainDataProviderOptions: MainDataProviderOptions(
        mockUpOptions: MockUpOptions(),
        sqLiteOptions: SQLiteOptions(
          databasePath: () async {
            final directory = await getApplicationSupportDirectory();
            return join(directory.path, 'default.db');
          },
          version: 1,
          onCreate: _dbInit,
        ),
        httpClientOptions: HTTPClientOptions(
          hostUrl: 'https://628e5ae9a339dfef87acd124.mockapi.io/api',
        ),
        sembastOptions: SembastOptions(
          databasePath: () async {
            final directory = await getApplicationSupportDirectory();
            return join(directory.path, 'sembast.db');
          },
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
