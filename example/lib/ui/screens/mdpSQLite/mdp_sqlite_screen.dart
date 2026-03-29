import 'package:example/model/sqlite_record.dart';
import 'package:example/model/sqlite_record_query.dart';
import 'package:example/model/dataRequests/get_sqlite_records_data_request.dart';
import 'package:example/model/dataTasks/delete_sqlite_record_data_task.dart';
import 'package:example/model/dataTasks/delete_sqlite_records_data_task.dart';
import 'package:example/ui/screens/abstract_app_screen.dart';
import 'package:example/ui/screens/mdpSQLite/mdp_sqlite_record_screen.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPSQLiteScreen extends AbstractAppScreen {
  static const String route = '/mdpsqlite';

  const MDPSQLiteScreen({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPSQLiteScreenState();
}

class _MDPSQLiteScreenState extends AbstractAppScreenState<MDPSQLiteScreen> {
  @override
  void initState() {
    super.initState();
    options = AppScreenStateOptions.drawer(
      screenName: MDPSQLiteScreen.route,
      title: tt('mdpsqlite.screen.title'),
    )..appBarOptions = <AppBarOption>[
        AppBarOption(
          onTap: (BuildContext context) {
            pushNamedV2(context, MDPSQLiteRecordScreen.route);
          },
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        AppBarOption(
          onTap: (BuildContext context) {
            MainDataProvider.instance!.executeDataTask(
              DeleteSQLiteRecordsDataTask(
                data: SQLiteRecordQuery.fromJson({
                  // 'name': 'a',
                }),
              ),
            );
          },
          icon: Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ];
  }

  @override
  Widget extraLargeDesktopScreen(BuildContext context) => _BodyWidget();

  @override
  Widget largeDesktopScreen(BuildContext context) => _BodyWidget();

  @override
  Widget largePhoneScreen(BuildContext context) => _BodyWidget();

  @override
  Widget smallDesktopScreen(BuildContext context) => _BodyWidget();

  @override
  Widget smallPhoneScreen(BuildContext context) => _BodyWidget();

  @override
  Widget tabletScreen(BuildContext context) => _BodyWidget();
}

class _BodyWidget extends AbstractStatefulWidget {
  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends AbstractStatefulWidgetState<_BodyWidget> {
  /// Create view layout from widgets
  @override
  Widget buildContent(BuildContext context) {
    return ListDataWidget<GetSQLiteRecordsDataRequest, SQLiteRecord>(
      dataRequest: GetSQLiteRecordsDataRequest(
        <String, dynamic>{},
      ),
      processResult: (GetSQLiteRecordsDataRequest dataRequest) {
        return dataRequest.result?.records;
      },
      buildItem: (BuildContext context, int position, SQLiteRecord item) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            child: SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(item.name)),
                  ],
                ),
              ),
            ),
            onLongPress: () {
              _deleteRecord(item);
            },
          ),
        );
      },
      buildLoadingItemWithGlobalKey: (BuildContext context, GlobalKey globalKey) {
        return LoadingItemWidget(
          containerKey: globalKey,
          text: Text(tt('list.item.loading')),
        );
      },
      emptyState: SizedBox(
        width: 576,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(tt('list.empty')),
        ),
      ),
    );
  }

  /// Delete selected Record from DB
  Future<void> _deleteRecord(SQLiteRecord record) {
    return MainDataProvider.instance!.executeDataTask<DeleteSQLiteRecordDataTask>(
      DeleteSQLiteRecordDataTask(
        data: record,
      ),
    );
  }
}
