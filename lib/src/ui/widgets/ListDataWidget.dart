import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tch_appliable_core/src/model/DataModel.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/DataRequest.dart';
import 'package:tch_appliable_core/src/ui/widgets/AbstractDataWidget.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

typedef ProcessResult<R extends DataRequest, I extends DataModel> = List<I>? Function(R dataRequest);

typedef ItemBuilder<I extends DataModel> = Widget Function(BuildContext context, int position, I item);

typedef BuildLoadingItemWithGlobalKey = Widget Function(BuildContext context, GlobalKey globalKey);

typedef BuildLoadingItemFullScreen = Widget Function(BuildContext context);

class ListDataWidget<R extends DataRequest, I extends DataModel> extends AbstractDataWidget {
  final ScrollController? scrollController;
  final ProcessResult<R, I> processResult;
  final ItemBuilder<I> buildItem;
  final BuildLoadingItemWithGlobalKey buildLoadingItemWithGlobalKey;
  final BuildLoadingItemFullScreen? buildLoadingItemFullScreen;
  final bool initialLoadingFullScreen;
  final Widget emptyState;
  final Widget? childAfterList;
  final PullToRefreshOptions pullToRefreshOptions;

  /// ListDataWidget initialization
  ListDataWidget({
    Key? key,
    this.scrollController,
    required R? dataRequest,
    required this.processResult,
    required this.buildItem,
    required this.buildLoadingItemWithGlobalKey,
    this.buildLoadingItemFullScreen,
    this.initialLoadingFullScreen = false,
    required this.emptyState,
    this.childAfterList,
    this.pullToRefreshOptions = const PullToRefreshOptions(),
  }) : super(key: key, dataRequests: <DataRequest>[if (dataRequest != null) dataRequest]);

  /// Create state for widget
  @override
  ListDataWidgetState<R, I> createState() => ListDataWidgetState<R, I>();
}

class ListDataWidgetState<R extends DataRequest, I extends DataModel> extends AbstractDataWidgetState<ListDataWidget<R, I>> {
  late ScrollController _scrollController;
  final RefreshController _refreshController = RefreshController();
  GlobalKey _loadingItemKey = GlobalKey();
  OverlayEntry? _loadingItemEntry;
  double _loadingItemHeight = 0;
  bool _isLastPage = false;
  List<I> _items = <I>[];
  int _itemsBeforeNextPage = 0;

  /// State initialization
  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? ScrollController();

    _scrollController.addListener(_isEndOfList);
  }

  /// Dispose of resources manually
  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }

    _refreshController.dispose();

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

        Widget loadingItem = widget.buildLoadingItemWithGlobalKey(context, _loadingItemKey);

        if (dataRequest.result != null) {
          final theLoadingItemEntry = _loadingItemEntry;
          if (theLoadingItemEntry != null) {
            _loadingItemEntry = null;

            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              theLoadingItemEntry.remove();
            });
          }

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
                if (!_isLastPage) loadingItem,
              ],
            );
          } else {
            return widget.emptyState;
          }
        } else {
          if (widget.initialLoadingFullScreen) {
            if (_loadingItemEntry == null) {
              _loadingItemEntry = OverlayEntry(builder: (BuildContext context) {
                return Material(
                  color: Colors.transparent,
                  child: widget.buildLoadingItemFullScreen?.call(context) ?? LoadingItemFullScreenWidget(),
                );
              });

              WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                Overlay.of(context)!.insert(_loadingItemEntry!);
              });
            }
          } else {
            content.add(loadingItem);
          }
        }

        final theChildAfterList = widget.childAfterList;
        if (theChildAfterList != null) {
          content.add(theChildAfterList);
        }

        Widget list = Scrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: content,
          ),
        );

        if (widget.pullToRefreshOptions.enabled) {
          list = SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            header: widget.pullToRefreshOptions.header,
            onRefresh: () => _refresh(),
            child: list,
          );
        }

        return list;
      },
    );
  }

  /// Calculate height of LoadingItem
  void _initLoadingItemHeight() {
    if (_loadingItemHeight > 0 || _loadingItemKey.currentContext == null) {
      return;
    }

    final RenderBox? loadingItemRenderBox = _loadingItemKey.currentContext?.findRenderObject() as RenderBox?;

    if (loadingItemRenderBox != null) {
      _loadingItemHeight = loadingItemRenderBox.size.height;
    }
  }

  /// Pull down refresh, reload data and optionally call custom callback
  Future<void> _refresh() async {
    final theCallback = widget.pullToRefreshOptions.callback;

    if (theCallback != null) {
      await theCallback();
    }

    final theDataSource = dataSource;

    if (widget.pullToRefreshOptions.refetchData && theDataSource != null) {
      await theDataSource.refetchData();
    }

    Future.delayed(kThemeAnimationDuration, () => _refreshController.refreshCompleted());
  }

  /// Reload data from the DataSource
  Future<void> refetchData() async {
    final theDataSource = dataSource;

    if (theDataSource != null) {
      return theDataSource.refetchData();
    }
  }

  /// Check if is scrolled to the end of list, call next page if yes
  void _isEndOfList() {
    if (_scrollController.hasClients) {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double scrolled = _scrollController.position.pixels;

      if (scrolled >= (maxScroll - _loadingItemHeight)) {
        _loadNextPage();
      }
    }
  }

  /// If is last item attempt to load next page
  void _loadNextPage() {
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

class LoadingItemFullScreenWidget extends StatelessWidget {
  /// Create view from widgets
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class PullToRefreshOptions {
  final bool enabled;
  final bool refetchData;
  final Future<void> Function()? callback;
  final Widget? header;

  /// PullToRefreshOptions initialization
  const PullToRefreshOptions({
    this.enabled = false,
    this.refetchData = true,
    this.callback,
    this.header,
  });
}
