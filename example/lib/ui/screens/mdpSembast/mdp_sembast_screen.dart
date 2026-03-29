import 'package:example/model/sembast_record.dart';
import 'package:example/model/sembast_record_query.dart';
import 'package:example/model/dataRequests/get_sembast_records_data_request.dart';
import 'package:example/model/dataTasks/delete_sembast_record_data_task.dart';
import 'package:example/model/dataTasks/delete_sembast_records_data_task.dart';
import 'package:example/ui/screens/abstract_app_screen.dart';
import 'package:example/ui/screens/mdpSembast/mdp_sembast_record_screen.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPSembastScreen extends AbstractAppScreen {
  static const String route = '/mdpsembast';

  const MDPSembastScreen({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPSembastScreenState();
}

class _MDPSembastScreenState extends AbstractAppScreenState<MDPSembastScreen> {
  @override
  void initState() {
    super.initState();
    options = AppScreenStateOptions.drawer(
      screenName: MDPSembastScreen.route,
      title: tt('mdpsembast.screen.title'),
    )..appBarOptions = <AppBarOption>[
        AppBarOption(
          onTap: (BuildContext context) {
            pushNamedV2(context, MDPSembastRecordScreen.route);
          },
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        AppBarOption(
          onTap: (BuildContext context) {
            MainDataProvider.instance!.executeDataTask(
              DeleteSembastRecordsDataTask(
                data: SembastRecordQuery.fromJson({
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
    return ListDataWidget<GetSembastRecordsDataRequest, SembastRecord>(
      dataRequest: GetSembastRecordsDataRequest(
        <String, dynamic>{},
      ),
      processResult: (GetSembastRecordsDataRequest dataRequest) {
        return dataRequest.result?.records;
      },
      buildItem: (BuildContext context, int position, SembastRecord item) {
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
  Future<void> _deleteRecord(SembastRecord record) {
    return MainDataProvider.instance!.executeDataTask<DeleteSembastRecordDataTask>(
      DeleteSembastRecordDataTask(
        data: record,
      ),
    );
  }
}
