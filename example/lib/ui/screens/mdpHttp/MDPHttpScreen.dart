import 'package:example/model/HttpRecord.dart';
import 'package:example/model/dataRequests/GetHttpRecordsDataRequest.dart';
import 'package:example/ui/screens/AbstractAppScreen.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPHttpScreen extends AbstractAppScreen {
  static const String ROUTE = "/mdphttp";

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPHttpScreenState();
}

class _MDPHttpScreenState extends AbstractAppScreenState<MDPHttpScreen> {
  @override
  AbstractScreenStateOptions options = AppScreenStateOptions.drawer(
    screenName: MDPHttpScreen.ROUTE,
    title: tt('mdphttp.screen.title'),
  );

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
    return ListDataWidget(
      dataRequest: GetHttpRecordsDataRequest(
        <String, dynamic>{},
      ),
      processResult: (GetHttpRecordsDataRequest dataRequest) {
        return dataRequest.result?.records;
      },
      buildItem: (BuildContext context, int position, HttpRecord item) {
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Text(item.name)),
              Spacer(),
              Text(item.createdAt),
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
