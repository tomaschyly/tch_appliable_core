import 'package:example/model/sembast_record.dart';
import 'package:example/model/dataRequests/get_mockup_records_data_request.dart';
import 'package:example/ui/screens/abstract_app_screen.dart';
import 'package:example/ui/screens/mdpMockup/mdp_mockup_task_screen.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPMockupScreen extends AbstractAppScreen {
  static const String route = '/mdpmockup';

  const MDPMockupScreen({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPMockupScreenState();
}

class _MDPMockupScreenState extends AbstractAppScreenState<MDPMockupScreen> {
  @override
  void initState() {
    super.initState();
    options = AppScreenStateOptions.drawer(
      screenName: MDPMockupScreen.route,
      title: tt('mdpmockup.screen.title'),
    )..appBarOptions = <AppBarOption>[
        AppBarOption(
          onTap: (BuildContext context) {
            pushNamedV2(context, MDPMockupTaskScreen.route);
          },
          icon: Icon(
            Icons.login,
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(tt('mdpmockup.screen.description')),
        ),
        Expanded(
          child: ListDataWidget<GetMockupRecordsDataRequest, SembastRecord>(
            dataRequest: GetMockupRecordsDataRequest(
              <String, dynamic>{},
            ),
            processResult: (GetMockupRecordsDataRequest dataRequest) {
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
                    // _deleteRecord(item); //TODO
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
          ),
        ),
      ],
    );
  }
}
