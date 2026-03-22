import 'package:example/model/HttpRecord.dart';
import 'package:example/model/HttpRecords.dart';
import 'package:example/model/dataRequests/GetHttpRecordsDataRequest.dart';
import 'package:example/ui/screens/AbstractAppScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class MDPHttpScreen extends AbstractAppScreen {
  static const String ROUTE = '/mdphttp';

  MDPHttpScreen({super.key});

  /// Create state for widget
  @override
  State<StatefulWidget> createState() => _MDPHttpScreenState();
}

class _MDPHttpScreenState extends AbstractAppScreenState<MDPHttpScreen> {
  @override
  AbstractScreenOptions options = AppScreenStateOptions.drawer(
    screenName: MDPHttpScreen.ROUTE,
    title: tt('mdphttp.screen.title'),
  )..appBarOptions = <AppBarOption>[
      AppBarOption(
        onTap: (BuildContext context) {
          MainDataProvider.instance!.reFetchData(
            MainDataProviderSource.HTTPClient,
            methods: [HttpRecords.METHOD],
          );
        },
        icon: SvgPicture.asset('images/arrows-rotate-solid.svg', colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn)),
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
        return SizedBox(
          height: 48,
          child: Padding(
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
}
