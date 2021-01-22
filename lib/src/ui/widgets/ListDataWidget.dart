import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/model/DataModel.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/DataRequest.dart';
import 'package:tch_appliable_core/src/ui/widgets/AbstractDataWidget.dart';

typedef ProcessResult<R extends DataRequest, I extends DataModel> = List<I>? Function(R dataRequest);

typedef ItemBuilder<I extends DataModel> = Widget Function(BuildContext context, int position, I item);

typedef BuildLoadingItemWithGlobalKey = Widget Function(BuildContext context, GlobalKey globalKey);

class ListDataWidget<R extends DataRequest, I extends DataModel> extends AbstractDataWidget {
  final ProcessResult<R, I> processResult;
  final ItemBuilder<I> buildItem;
  final BuildLoadingItemWithGlobalKey buildLoadingItemWithGlobalKey;
  final Widget emptyState;
  final Widget? childAfterList;

  /// ListDataWidget initialization
  ListDataWidget({
    Key? key,
    required R? dataRequest,
    required this.processResult,
    required this.buildItem,
    required this.buildLoadingItemWithGlobalKey,
    required this.emptyState,
    this.childAfterList,
  }) : super(key: key, dataRequests: <DataRequest>[if (dataRequest != null) dataRequest]);

  /// Create state for widget
  @override
  ListDataWidgetState<R, I> createState() => ListDataWidgetState<R, I>();
}

class ListDataWidgetState<R extends DataRequest, I extends DataModel> extends AbstractDataWidgetState<ListDataWidget<R, I>> {
  final ScrollController _scrollController = ScrollController();
  GlobalKey _loadingItemKey = GlobalKey();
  double _loadingItemHeight = 0;
  bool _isLastPage = false;
  List<I> _items = <I>[];
  int _itemsBeforeNextPage = 0;

  /// State initialization
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_isEndOfList);
  }

  /// Dispose of resources manually
  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  /// Create screen content from widgets
  @override
  Widget buildContent(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => _initLoadingItemHeight());

    final theDataSource = dataSource;
    if (theDataSource == null) {
      return widget.emptyState;
    }

    return ValueListenableBuilder(
      valueListenable: theDataSource.results,
      builder: (BuildContext context, List<DataRequest> dataRequests, Widget? child) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => _isEndOfList());

        final List<Widget> content = <Widget>[];

        final R dataRequest = dataRequests.first as R;

        if (dataRequest.result != null) {
          final List<I>? items = widget.processResult(dataRequest);
          _items = items ?? <I>[];

          if (items?.isNotEmpty == true) {
            content.addAll(
              <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int position) {
                      return widget.buildItem(context, position, _items[position]);
                    },
                    childCount: _items.length,
                  ),
                ),
                if (!_isLastPage) widget.buildLoadingItemWithGlobalKey(context, _loadingItemKey),
              ],
            );
          } else {
            return widget.emptyState;
          }
        } else {
          content.add(widget.buildLoadingItemWithGlobalKey(context, _loadingItemKey));
        }

        final theChildAfterList = widget.childAfterList;
        if (theChildAfterList != null) {
          content.add(theChildAfterList);
        }

        return Scrollbar(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: content,
          ),
        );
      },
    );
  }

  /// Calculate height of LoadingItem
  _initLoadingItemHeight() {
    if (_loadingItemHeight > 0 || _loadingItemKey.currentContext == null) {
      return;
    }

    final RenderBox? loadingItemRenderBox = _loadingItemKey.currentContext?.findRenderObject() as RenderBox?;

    if (loadingItemRenderBox != null) {
      _loadingItemHeight = loadingItemRenderBox.size.height;
    }
  }

  /// Check if is scrolled to the end of list, call next page if yes
  _isEndOfList() {
    if (_scrollController.hasClients) {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double scrolled = _scrollController.position.pixels;

      if (scrolled >= (maxScroll - _loadingItemHeight)) {
        _loadNextPage();
      }
    }
  }

  /// If is last item attempt to load next page
  _loadNextPage() {
    if (_isLastPage) {
      return;
    }

    if (_itemsBeforeNextPage == _items.length) {
      return;
    }
    _itemsBeforeNextPage = _items.length;

    if (dataSource?.hasNextPageOfRequest<R>() == true) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        dataSource?.requestNextPageOfRequest<R>();
      });
    } else {
      _isLastPage = true;

      setStateNotDisposed(() {});
    }
  }

  /// Get previous item if able
  I? previousItem(int position) {
    if (position > 0) {
      return _items[position - 1];
    }

    return null;
  }
}

class LoadingItemWidget extends StatelessWidget {
  final Key? containerKey;
  final Text text;

  /// LoadingItemWidget initialization
  LoadingItemWidget({
    this.containerKey,
    required this.text,
  });

  /// Create view from widgets
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          key: containerKey,
          height: 48,
          child: Center(
            child: text,
          ),
        ),
      ]),
    );
  }
}
