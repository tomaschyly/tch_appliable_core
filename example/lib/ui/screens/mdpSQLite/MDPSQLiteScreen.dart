import 'package:example/model/SQLiteRecord.dart';
import 'package:example/model/dataRequests/GetSQLiteRecordsDataRequest.dart';
import 'package:example/ui/screens/AbstractAppScreen.dart';
import 'package:example/ui/screens/mdpSQLite/MDPSQLiteRecordScreen.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPSQLiteScreen extends AbstractAppScreen {
  static const String ROUTE = "/mdpsqlite";

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPSQLiteScreenState();
}

class _MDPSQLiteScreenState extends AbstractAppScreenState<MDPSQLiteScreen> {
  @override
  AppScreenStateOptions get options => AppScreenStateOptions.drawer(
        screenName: MDPSQLiteScreen.ROUTE,
        title: tt('mdpsqlite.screen.title'),
      )..appBarOptions = <AppBarOption>[
          AppBarOption(
            onTap: (BuildContext context) {
              pushNamed(context, MDPSQLiteRecordScreen.ROUTE);
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ];

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
  /// BodyWidget initialization
  _BodyWidget({Key? key}) : super(key: key);

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
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(item.name),
            ],
          ),
        );
      },
      buildLoadingItemWithGlobalKey: (BuildContext context, GlobalKey globalKey) {
        return LoadingItemWidget(
          containerKey: globalKey,
          text: Text(tt('list.item.loading')),
        );
      },
      emptyState: Container(
        width: 576,
        padding: const EdgeInsets.all(16),
        child: Text(tt('list.empty')),
      ),
    );
  }
}
