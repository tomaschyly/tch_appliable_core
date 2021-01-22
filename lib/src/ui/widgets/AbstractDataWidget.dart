import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/providers/MainDataProvider.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/DataRequest.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/MainDataSource.dart';
import 'package:tch_appliable_core/src/ui/widgets/AbstractStatefulWidget.dart';

abstract class AbstractDataWidget extends AbstractStatefulWidget {
  @protected
  final List<DataRequest> dataRequests;

  /// AbstractDataWidget initialization
  AbstractDataWidget({
    Key? key,
    required this.dataRequests,
  }) : super(key: key);
}

abstract class AbstractDataWidgetState<T extends AbstractDataWidget> extends AbstractStatefulWidgetState<T> {
  @protected
  MainDataSource? get dataSource => _dataSource;

  @protected
  bool get allowDidUpdateWidget => false;

  List<DataRequest> _dataRequests = <DataRequest>[];
  MainDataSource? _dataSource;

  /// State initialization
  @override
  void initState() {
    super.initState();

    _dataRequests = widget.dataRequests;

    _registerDataRequests();
  }

  /// Manually dispose of resources
  @override
  void dispose() {
    _unRegisterDataRequests();

    super.dispose();
  }

  /// Widget updated
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (allowDidUpdateWidget && oldWidget.dataRequests != widget.dataRequests) {
      updateDataRequests(widget.dataRequests);
    }
  }

  /// Register DataRequests of this widget with the DataProvider
  void _registerDataRequests() {
    if (_dataRequests.isNotEmpty) {
      final bool isFirst = _dataSource == null;

      _dataSource = MainDataProvider.instance!.registerDataRequests(_dataRequests);

      if (isFirst) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => setStateNotDisposed(() {}));
      }
    }
  }

  /// UnRegister DataRequest of this widget from the DataProvider
  void _unRegisterDataRequests() {
    final dataSource = _dataSource;
    if (dataSource != null) {
      MainDataProvider.instance!.unRegisterDataRequests(dataSource);
      _dataSource = null;
    }
  }

  /// To update DataRequests unRegister old DataRequests and register new DataRequest
  void updateDataRequests(List<DataRequest> dataRequests) {
    _unRegisterDataRequests();

    _dataRequests = dataRequests;

    _registerDataRequests();
  }

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    if (widgetState == WidgetState.NotInitialized) {
      firstBuildOnly(context);
    }

    if (_dataSource == null) {
      return Builder(
        builder: (BuildContext context) => buildContentUnAvailable(context),
      );
    }

    return ValueListenableBuilder(
      valueListenable: _dataSource!.state,
      builder: (BuildContext context, MainDataProviderSourceState state, Widget? child) {
        switch (state) {
          case MainDataProviderSourceState.UnAvailable:
            return buildContentUnAvailable(context);
          case MainDataProviderSourceState.Ready:
            return buildContent(context);
          case MainDataProviderSourceState.Connecting:
            return buildContentConnecting(context);
        }
      },
    );
  }

  /// Create screen content from widgets when at least one Request Source is unAvailable
  @protected
  Widget buildContentUnAvailable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text('MainDataSource or provider source unAvailable'),
      ),
    );
  }

  /// Create screen content from widgets when at least one Request Source is Connecting
  @protected
  Widget buildContentConnecting(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text('Provider source is connecting'),
      ),
    );
  }
}
