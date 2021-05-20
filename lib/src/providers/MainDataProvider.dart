import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sembast/sembast.dart' as Sembast;
import 'package:sembast/sembast_io.dart';
import 'package:sqflite/sqflite.dart' as SQLite;
import 'package:tch_appliable_core/src/providers/mainDataProvider/DataRequest.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/DataTask.dart';
import 'package:tch_appliable_core/src/providers/mainDataProvider/MainDataSource.dart';
import 'package:tch_appliable_core/utils/List.dart';

enum MainDataProviderSource {
  None,
  MockUp,
  HTTPClient,
  SQLite,
  Sembast,
}

class MainDataProviderOptions {
  MockUpOptions? mockUpOptions;
  HTTPClientOptions? httpClientOptions;
  SQLiteOptions? sqLiteOptions;
  SembastOptions? sembastOptions;

  /// MainDataProviderOptions initialization
  MainDataProviderOptions({
    this.mockUpOptions,
    this.httpClientOptions,
    this.sqLiteOptions,
    this.sembastOptions,
  });
}

class MainDataProvider {
  static MainDataProvider? get instance => _instance;

  static MainDataProvider? _instance;

  List<AbstractSource> get initializedSources => _initializedSources.toList(growable: false);

  final MainDataProviderOptions _options;
  List<AbstractSource> _initializedSources = <AbstractSource>[];

  /// MainDataProvider initialization
  MainDataProvider({
    required MainDataProviderOptions options,
  }) : _options = options {
    _instance = this;

    final theMockUpOptions = options.mockUpOptions;
    if (theMockUpOptions != null) {
      _initializedSources.add(MockUpSource(options: theMockUpOptions));
    }

    final theHttpClientOptions = options.httpClientOptions;
    if (theHttpClientOptions != null) {
      _initializedSources.add(HTTPSource(options: theHttpClientOptions));
    }

    final theSqLiteOptions = options.sqLiteOptions;
    if (theSqLiteOptions != null) {
      _initializedSources.add(SQLiteSource(options: theSqLiteOptions));
    }

    final theSembastOptions = options.sembastOptions;
    if (theSembastOptions != null) {
      _initializedSources.add(SembastSource(options: theSembastOptions));
    }
  }

  /// Get source if it was initialized
  AbstractSource? _initialitedSource(MainDataProviderSource source) {
    AbstractSource? theSource;

    switch (source) {
      case MainDataProviderSource.MockUp:
        theSource = _initializedSources.firstWhereOrNull((element) => element is MockUpSource);
        break;
      case MainDataProviderSource.HTTPClient:
        theSource = _initializedSources.firstWhereOrNull((element) => element is HTTPSource);
        break;
      case MainDataProviderSource.SQLite:
        theSource = _initializedSources.firstWhereOrNull((element) => element is SQLiteSource);
        break;
      case MainDataProviderSource.Sembast:
        theSource = _initializedSources.firstWhereOrNull((element) => element is SembastSource);
        break;
      default:
        throw Exception('Cannot get not implemented source $source');
    }

    return theSource;
  }

  /// Create new DataSource for DataRequests and register it to source for data, will throw Exception if you try to register on not initialized source
  MainDataSource registerDataRequests(List<DataRequest> dataRequests) {
    final MainDataSource dataSource = MainDataSource(dataRequests);

    for (DataRequest dataRequest in dataRequests) {
      AbstractSource? theSource = _initialitedSource(dataRequest.source);

      if (theSource == null) {
        throw Exception('Cannot register for not initialized source ${dataRequest.source}');
      }

      theSource.registerDataSource(dataSource);
    }

    return dataSource;
  }

  /// UnRegister the DataSource from source/s
  void unRegisterDataRequests(MainDataSource dataSource) {
    for (MainDataProviderSource source in dataSource.sources) {
      AbstractSource? theSource = _initialitedSource(source);

      if (theSource == null) {
        throw Exception('Cannot unRegister for not initialized source $source');
      }

      theSource.unRegisterDataSource(dataSource);
    }
  }

  /// Check if DataRequest has next page
  bool dataRequestHasNextPage(DataRequest dataRequest) {
    AbstractSource? theSource = _initialitedSource(dataRequest.source);

    if (theSource == null) {
      throw Exception('Cannot check nextPage for not initialized source ${dataRequest.source}');
    }

    return theSource.dataRequestHasNextPage(dataRequest);
  }

  /// Request to load next page of DataRequest
  dataRequestLoadNextPage(DataRequest dataRequest) {
    AbstractSource? theSource = _initialitedSource(dataRequest.source);

    if (theSource == null) {
      throw Exception('Cannot load nextPage for not initialized source ${dataRequest.source}');
    }

    theSource.dataRequestLoadNextPage(dataRequest);
  }

  /// Async execute one time DataTask using initialized source
  Future<T> executeDataTask<T extends DataTask>(T dataTask) {
    AbstractSource? theSource;

    if (dataTask.options is MockUpTaskOptions) {
      theSource = _initializedSources.firstWhereOrNull((element) => element is MockUpSource);
    } else if (dataTask.options is HTTPTaskOptions) {
      theSource = _initializedSources.firstWhereOrNull((element) => element is HTTPSource);
    } else if (dataTask.options is SQLiteTaskOptions) {
      theSource = _initializedSources.firstWhereOrNull((element) => element is SQLiteSource);
    } else if (dataTask.options is SembastTaskOptions) {
      theSource = _initializedSources.firstWhereOrNull((element) => element is SembastSource);
    } else {
      throw Exception('Cannot get not implemented source for options ${dataTask.options}');
    }

    if (theSource == null) {
      throw Exception('Cannot execute DataTask for not initialized source for options ${dataTask.options}');
    }

    return theSource.executeDataTask<T>(dataTask);
  }

  /// ReFetch data for DataRequest of initialized source based on methods or identifiers
  Future<void> reFetchData(MainDataProviderSource source, {List<String>? methods, List<String>? identifiers}) {
    AbstractSource? theSource = _initialitedSource(source);

    if (theSource == null) {
      throw Exception('Cannot reFetchData for not initialized source $source');
    }

    return theSource.reFetchData(methods: methods, identifiers: identifiers);
  }

  /// Update the of MainDataSource based on state of sources used by it
  void _updateMainDataSourceState(MainDataSource mainDataSource) {
    final List<MainDataProviderSourceState> states = [];

    mainDataSource.sources.forEach((MainDataProviderSource source) {
      AbstractSource? theSource = _initialitedSource(source);

      if (theSource == null) {
        states.add(MainDataProviderSourceState.UnAvailable);
      } else {
        states.add(theSource.state.value);
      }
    });

    if (states.contains(MainDataProviderSourceState.UnAvailable)) {
      mainDataSource.state.value = MainDataProviderSourceState.UnAvailable;
    } else if (states.contains(MainDataProviderSourceState.Connecting)) {
      mainDataSource.state.value = MainDataProviderSourceState.Connecting;
    } else {
      mainDataSource.state.value = MainDataProviderSourceState.Ready;
    }
  }
}

enum MainDataProviderSourceState {
  UnAvailable,
  Ready,
  Connecting,
}

abstract class AbstractSource {
  MainDataProviderSource get isSource;
  ValueNotifier<MainDataProviderSourceState> state = ValueNotifier(MainDataProviderSourceState.UnAvailable);

  final List<MainDataSource> _dataSources = <MainDataSource>[];
  final List<String> _identifiers = <String>[];
  final Map<String, DataRequest> _identifierRequests = Map();

  /// Register the DataSource for data
  registerDataSource(MainDataSource dataSource);

  /// Register DataSource DataRequests for identifiers and example DataRequests mapping
  @protected
  registerDataRequests(MainDataSource dataSource) {
    dataSource.identifiers.forEach((String identifier) {
      if (_identifiers.contains(identifier)) {
        final DataRequest dataRequest = dataSource.requestForIdentifier(identifier)!;

        if (dataRequest.source != isSource) {
          return;
        }

        _identifiers.add(identifier);

        _identifierRequests[identifier] = dataRequest;
      }
    });
  }

  /// UnRegister the DataSource from receiving data
  unRegisterDataSource(MainDataSource dataSource);

  /// UnRegister DataSource DataRequests for identifiers if no other DataSource has equal
  @protected
  unRegisterDataRequests(MainDataSource dataSource) {
    dataSource.identifiers.forEach((String identifier) {
      final DataRequest dataRequest = dataSource.requestForIdentifier(identifier)!;

      if (dataRequest.source != isSource) {
        return;
      }

      for (MainDataSource otherDataSource in _dataSources) {
        if (otherDataSource != dataSource) {
          for (String otherDataSourceMethod in otherDataSource.identifiers) {
            if (otherDataSourceMethod == identifier) {
              return;
            }
          }
        }
      }

      _identifiers.remove(identifier);

      _identifierRequests.remove(identifier);
    });
  }

  /// Check if DataRequest has next page
  bool dataRequestHasNextPage(DataRequest dataRequest);

  /// Request to load next page of DataRequest
  dataRequestLoadNextPage(DataRequest dataRequest);

  /// Execute one time DataTask against the source
  Future<T> executeDataTask<T extends DataTask>(T dataTask);

  /// ReFetch data for DataRequest based on methods or identifiers
  Future<void> reFetchData({List<String>? methods, List<String>? identifiers});
}

class MockUpOptions {}

class MockUpSource extends AbstractSource {
  @override
  MainDataProviderSource get isSource => MainDataProviderSource.MockUp;

  final MockUpOptions _options;

  /// MockUpSource initialization
  MockUpSource({
    required MockUpOptions options,
  }) : _options = options {
    state = ValueNotifier(MainDataProviderSourceState.Ready);
  }

  /// Register the DataSource for data
  @override
  registerDataSource(MainDataSource dataSource) {
    throw Exception('MockUpSource is not implemented');
  }

  /// UnRegister the DataSource from receiving data
  @override
  unRegisterDataSource(MainDataSource dataSource) {
    throw Exception('MockUpSource is not implemented');
  }

  /// Check if DataRequest has next page
  @override
  bool dataRequestHasNextPage(DataRequest dataRequest) {
    throw Exception('MockUpSource is not implemented');
  }

  /// Request to load next page of DataRequest
  @override
  dataRequestLoadNextPage(DataRequest dataRequest) {
    throw Exception('MockUpSource is not implemented');
  }

  /// Execute one time DataTask against the source
  @override
  Future<T> executeDataTask<T extends DataTask>(T dataTask) {
    throw Exception('MockUpSource is not implemented');
  }

  /// ReFetch data for DataRequest based on methods or identifiers
  @override
  Future<void> reFetchData({List<String>? methods, List<String>? identifiers}) {
    throw Exception('MockUpSource is not implemented');
  }
}

class HTTPClientOptions {
  final String hostUrl;
  final Map<String, String>? headers;

  /// HTTPClientOptions initialization
  HTTPClientOptions({
    required this.hostUrl,
    this.headers,
  }) : assert(hostUrl.isNotEmpty);
}

class HTTPSource extends AbstractSource {
  @override
  MainDataProviderSource get isSource => MainDataProviderSource.HTTPClient;

  final HTTPClientOptions _options;

  /// HTTPSource initialization
  HTTPSource({
    required HTTPClientOptions options,
  }) : _options = options {
    state = ValueNotifier(MainDataProviderSourceState.Ready);
  }

  /// Query data from remote API
  Future<String?> query(DataRequest dataRequest) async {
    final List<String> values = [];
    dataRequest.parameters.forEach((key, value) {
      values.add('$key=$value');
    });

    final String url = '${_options.hostUrl}${dataRequest.method}?${values.join('&')}';

    try {
      final Response response = await get(
        Uri.parse(url),
        headers: _options.headers,
      );

      return response.body;
    } catch (e) {
      debugPrint('HTTPSource.query error: $e');
    }

    return null;
  }

  /// Query data from remote API and update DataSources
  Future<void> _queryDataUpdate(DataRequest dataRequest) async {
    final String? response = await query(dataRequest);

    _dataSources.forEach((MainDataSource dataSource) {
      if (dataSource.identifiers.contains(dataRequest.identifier)) {
        dataSource.setResult(dataRequest.identifier, <String, dynamic>{
          'response': response,
        });
      }
    });
  }

  /// Register the DataSource for data
  @override
  registerDataSource(MainDataSource dataSource) {
    _dataSources.add(dataSource);

    registerDataRequests(dataSource);

    MainDataProvider.instance!._updateMainDataSourceState(dataSource);

    reFetchData(identifiers: dataSource.identifiers);
  }

  /// UnRegister the DataSource from receiving data
  @override
  unRegisterDataSource(MainDataSource dataSource) {
    unRegisterDataRequests(dataSource);

    _dataSources.remove(dataSource);

    dataSource.dispose();
  }

  /// Check if DataRequest has next page
  @override
  bool dataRequestHasNextPage(DataRequest dataRequest) {
    throw Exception('HTTPSource is not implemented');
  }

  /// Request to load next page of DataRequest
  @override
  dataRequestLoadNextPage(DataRequest dataRequest) {
    throw Exception('HTTPSource is not implemented');
  }

  /// Execute one time DataTask against the source
  @override
  Future<T> executeDataTask<T extends DataTask>(T dataTask) async {
    final options = dataTask.options as HTTPTaskOptions;

    final String hostUrl = options.url ?? _options.hostUrl;
    final Map<String, dynamic> data = dataTask.data.toJson();

    switch (options.type) {
      case HTTPType.Get:
        final List<String> values = [];
        data.forEach((key, value) {
          values.add('$key=$value');
        });

        final String url = '$hostUrl?${values.join('&')}';

        try {
          final Response response = await get(
            Uri.parse(url),
            headers: options.headers,
          );

          if (options.processBody != null) {
            final result = options.processBody!(response.body);

            dataTask.result = dataTask.processResult(result);
          } else {
            dataTask.result = dataTask.processResult(jsonDecode(response.body));
          }
        } catch (e) {
          debugPrint('HTTPSource.executeDataTask error: $e');

          dataTask.result = null;
        }
        break;
      case HTTPType.Post:
        try {
          final Response response = await post(
            Uri.parse(hostUrl),
            headers: options.headers,
            body: data,
          );

          if (options.processBody != null) {
            final result = options.processBody!(response.body);

            dataTask.result = dataTask.processResult(result);
          } else {
            dataTask.result = dataTask.processResult(jsonDecode(response.body));
          }
        } catch (e) {
          debugPrint('HTTPSource.executeDataTask error: $e');

          dataTask.result = null;
        }
        break;
    }

    if (dataTask.reFetchMethods != null) {
      await reFetchData(methods: dataTask.reFetchMethods);
    }

    return dataTask;
  }

  /// ReFetch data for DataRequest based on methods or identifiers
  @override
  Future<void> reFetchData({List<String>? methods, List<String>? identifiers}) async {
    if (methods == null && identifiers == null) {
      throw Exception('Provide either methods or identifiers');
    }

    if (methods != null) {
      final List<String> identifiers = <String>[];

      for (String method in methods) {
        for (MainDataSource dataSource in _dataSources) {
          final DataRequest? dataRequest = dataSource.requestForMethod(method);

          if (dataRequest != null && !identifiers.contains(dataRequest.identifier)) {
            identifiers.add(dataRequest.identifier);
          }
        }
      }

      await reFetchData(identifiers: identifiers);
    }

    if (identifiers != null) {
      for (String identifier in identifiers) {
        for (MainDataSource dataSource in _dataSources) {
          final DataRequest? dataRequest = dataSource.requestForIdentifier(identifier);

          if (dataRequest != null) {
            await _queryDataUpdate(dataRequest);
            break;
          }
        }
      }
    }
  }
}

class SQLiteOptions {
  final Future<String> Function() databasePath;
  final int version;
  final SQLite.OnDatabaseCreateFn onCreate;
  final SQLite.OnDatabaseVersionChangeFn? onUpgrade;
  final SQLite.OnDatabaseVersionChangeFn? onDowngrade;

  /// SQLiteOptions initialization
  SQLiteOptions({
    required this.databasePath,
    required this.version,
    required this.onCreate,
    this.onUpgrade,
    this.onDowngrade,
  });
}

class SQLiteSource extends AbstractSource {
  @override
  MainDataProviderSource get isSource => MainDataProviderSource.SQLite;

  final SQLiteOptions _options;
  SQLite.Database? _database;

  /// SQLiteSource initialization
  SQLiteSource({
    required SQLiteOptions options,
  }) : _options = options {
    state = ValueNotifier(MainDataProviderSourceState.Ready);
  }

  /// Create Database connection and init tables structure
  Future<SQLite.Database> _open() async {
    SQLite.Database? database = _database;

    if (database == null) {
      database = await SQLite.openDatabase(
        await _options.databasePath(),
        version: _options.version,
        onCreate: _options.onCreate,
        onUpgrade: _options.onUpgrade,
        onDowngrade: _options.onDowngrade,
      );

      _database = database;
    }

    return database;
  }

  /// Run any raw SQL command/query on the database
  Future<void> raw(String query) async {
    final database = await _open();

    return database.execute(query);
  }

  /// Query data from database
  Future<List<Map<String, dynamic>>> query(String table, Map<String, dynamic> parameters, {String? rawQuery, List<dynamic>? rawArguments}) async {
    final database = await _open();

    if (rawQuery?.isNotEmpty == true) {
      final List<Map<String, dynamic>> results = await database.rawQuery(rawQuery!, rawArguments);

      return results;
    }

    String? where;
    List<dynamic>? whereArgs;

    if (parameters.isNotEmpty) {
      where = parameters.keys.join(' ');
      whereArgs = parameters.values.toList();
    }

    final List<Map<String, dynamic>> results = await database.query(table, where: where, whereArgs: whereArgs);

    return results;
  }

  /// Insert data into database
  Future<int> _insert(String table, Map<String, dynamic> data) async {
    final database = await _open();

    return database.insert(table, data);
  }

  /// Update data in database
  Future<int> _update(String table, Map<String, dynamic> data, int id) async {
    final database = await _open();

    return database.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  /// Insert or update depending on if existing already
  Future<int> save(String table, Map<String, dynamic> data, {int? id}) async {
    if (id != null && id > 0) {
      await _update(table, data, id);

      return id;
    } else {
      return _insert(table, data);
    }
  }

  /// Delete data from database
  Future<int> delete(String table, int id) async {
    final database = await _open();

    return database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /// Query data from database and update DataSources
  Future<void> _queryDataUpdate(DataRequest dataRequest) async {
    final List<Map<String, dynamic>> results = await query(dataRequest.method, dataRequest.parameters);

    _dataSources.forEach((MainDataSource dataSource) {
      if (dataSource.identifiers.contains(dataRequest.identifier)) {
        dataSource.setResult(dataRequest.identifier, <String, dynamic>{
          'list': results,
        });
      }
    });
  }

  /// Register the DataSource for data
  @override
  registerDataSource(MainDataSource dataSource) {
    _dataSources.add(dataSource);

    registerDataRequests(dataSource);

    MainDataProvider.instance!._updateMainDataSourceState(dataSource);

    reFetchData(identifiers: dataSource.identifiers);
  }

  /// UnRegister the DataSource from receiving data
  @override
  unRegisterDataSource(MainDataSource dataSource) {
    unRegisterDataRequests(dataSource);

    _dataSources.remove(dataSource);

    dataSource.dispose();
  }

  /// Check if DataRequest has next page
  @override
  bool dataRequestHasNextPage(DataRequest dataRequest) {
    throw Exception('SQLiteSource is not implemented');
  }

  /// Request to load next page of DataRequest
  @override
  dataRequestLoadNextPage(DataRequest dataRequest) {
    throw Exception('SQLiteSource is not implemented');
  }

  /// Execute one time DataTask against the source
  @override
  Future<T> executeDataTask<T extends DataTask>(T dataTask) async {
    final options = dataTask.options as SQLiteTaskOptions;

    final Map<String, dynamic> data = dataTask.data.toJson();

    switch (options.type) {
      case SQLiteType.Raw:
        await raw(options.rawQuery!);
        break;
      case SQLiteType.Query:
        final List<Map<String, dynamic>> results = await query(
          dataTask.method,
          data,
          rawQuery: options.rawQuery,
          rawArguments: options.rawArguments,
        );

        dataTask.result = dataTask.processResult(<String, dynamic>{
          'list': results,
        });
        break;
      case SQLiteType.Save:
        final int id = await save(
          dataTask.method,
          data,
          id: data[options.idKey],
        );

        dataTask.result = dataTask.processResult(<String, dynamic>{'id': id});
        break;
      case SQLiteType.Delete:
        final int deleted = await delete(
          dataTask.method,
          data[options.idKey],
        );

        dataTask.result = dataTask.processResult(<String, dynamic>{'deleted': deleted});
        break;
    }

    if (dataTask.reFetchMethods != null) {
      await reFetchData(methods: dataTask.reFetchMethods);
    }

    return dataTask;
  }

  /// ReFetch data for DataRequest based on methods or identifiers
  @override
  Future<void> reFetchData({List<String>? methods, List<String>? identifiers}) async {
    if (methods == null && identifiers == null) {
      throw Exception('Provide either methods or identifiers');
    }

    if (methods != null) {
      final List<String> identifiers = <String>[];

      for (String method in methods) {
        for (MainDataSource dataSource in _dataSources) {
          final DataRequest? dataRequest = dataSource.requestForMethod(method);

          if (dataRequest != null && !identifiers.contains(dataRequest.identifier)) {
            identifiers.add(dataRequest.identifier);
          }
        }
      }

      await reFetchData(identifiers: identifiers);
    }

    if (identifiers != null) {
      for (String identifier in identifiers) {
        for (MainDataSource dataSource in _dataSources) {
          final DataRequest? dataRequest = dataSource.requestForIdentifier(identifier);

          if (dataRequest != null) {
            await _queryDataUpdate(dataRequest);
            break;
          }
        }
      }
    }
  }
}

class SembastOptions {
  final Future<String> Function() databasePath;

  /// SembastOptions initialization
  SembastOptions({
    required this.databasePath,
  });
}

class SembastSource extends AbstractSource {
  @override
  MainDataProviderSource get isSource => MainDataProviderSource.Sembast;

  final SembastOptions _options;
  Sembast.Database? _database;

  /// SembastSource initialization
  SembastSource({
    required SembastOptions options,
  }) : _options = options {
    state = ValueNotifier(MainDataProviderSourceState.Ready);
  }

  /// Create Database connection
  Future<Sembast.Database> _open() async {
    Sembast.Database? database = _database;

    if (database == null) {
      Sembast.DatabaseFactory dbFactory = databaseFactoryIo;

      database = await dbFactory.openDatabase(await _options.databasePath());

      _database = database;
    }

    return database;
  }

  /// Insert data into database store with int as autoincrement
  Future<int> _insert(String store, Map<String, dynamic> data) async {
    final database = await _open();

    final theStore = Sembast.intMapStoreFactory.store(store);

    return theStore.add(database, data);
  }

  /// Update data in database store for id
  Future<void> _update(String store, Map<String, dynamic> data, int id) async {
    final database = await _open();

    final theStore = Sembast.intMapStoreFactory.store(store);

    await theStore.record(id).put(database, data);
  }

  /// Insert or update depending on if existing already
  Future<int> save(String store, Map<String, dynamic> data, {int? id}) async {
    if (id != null && id > 0) {
      await _update(store, data, id);

      return id;
    } else {
      return _insert(store, data);
    }
  }

  /// Delete data from database store for id
  Future<void> delete(String store, int id) async {
    final database = await _open();

    final theStore = Sembast.intMapStoreFactory.store(store);

    await theStore.record(id).delete(database);
  }

  /// Register the DataSource for data
  @override
  registerDataSource(MainDataSource dataSource) {
    _dataSources.add(dataSource);

    registerDataRequests(dataSource);

    MainDataProvider.instance!._updateMainDataSourceState(dataSource);

    reFetchData(identifiers: dataSource.identifiers);
  }

  /// UnRegister the DataSource from receiving data
  @override
  unRegisterDataSource(MainDataSource dataSource) {
    unRegisterDataRequests(dataSource);

    _dataSources.remove(dataSource);

    dataSource.dispose();
  }

  /// Check if DataRequest has next page
  @override
  bool dataRequestHasNextPage(DataRequest dataRequest) {
    throw Exception('SembastSource is not implemented');
  }

  /// Request to load next page of DataRequest
  @override
  dataRequestLoadNextPage(DataRequest dataRequest) {
    throw Exception('SembastSource is not implemented');
  }

  /// Execute one time DataTask against the source
  @override
  Future<T> executeDataTask<T extends DataTask>(T dataTask) async {
    final options = dataTask.options as SembastTaskOptions;

    final Map<String, dynamic> data = dataTask.data.toJson();

    switch (options.type) {
      case SembastType.Query:
        //TODO
        throw Exception("SembastSource query Task is not implemented");
        break;
      case SembastType.Save:
        final int id = await save(
          dataTask.method,
          data,
          id: data[options.idKey],
        );

        dataTask.result = dataTask.processResult(<String, dynamic>{'id': id});
        break;
      case SembastType.Delete:
        await delete(dataTask.method, data[options.idKey]);

        dataTask.result = dataTask.processResult(<String, dynamic>{'deleted': true});
        break;
    }

    if (dataTask.reFetchMethods != null) {
      await reFetchData(methods: dataTask.reFetchMethods);
    }

    return dataTask;
  }

  /// ReFetch data for DataRequest based on methods or identifiers
  @override
  Future<void> reFetchData({List<String>? methods, List<String>? identifiers}) async {
    if (methods == null && identifiers == null) {
      throw Exception('Provide either methods or identifiers');
    }

    if (methods != null) {
      final List<String> identifiers = <String>[];

      for (String method in methods) {
        for (MainDataSource dataSource in _dataSources) {
          final DataRequest? dataRequest = dataSource.requestForMethod(method);

          if (dataRequest != null && !identifiers.contains(dataRequest.identifier)) {
            identifiers.add(dataRequest.identifier);
          }
        }
      }

      await reFetchData(identifiers: identifiers);
    }

    if (identifiers != null) {
      for (String identifier in identifiers) {
        for (MainDataSource dataSource in _dataSources) {
          final DataRequest? dataRequest = dataSource.requestForIdentifier(identifier);

          if (dataRequest != null) {
            // await _queryDataUpdate(dataRequest); //TODO
            break;
          }
        }
      }
    }
  }
}
