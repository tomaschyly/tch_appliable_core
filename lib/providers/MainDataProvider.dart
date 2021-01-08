import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tch_appliable_core/providers/mainDataProvider/DataRequest.dart';
import 'package:tch_appliable_core/providers/mainDataProvider/DataTask.dart';
import 'package:tch_appliable_core/providers/mainDataProvider/MainDataSource.dart';

enum MainDataProviderSource {
  None,
  MockUp,
  HTTPClient,
  SQLite,
}

class MainDataProviderOptions {
  MockUpOptions? mockUpOptions;
  HTTPClientOptions? httpClientOptions;
  SQLiteOptions? sqLiteOptions;

  /// MainDataProviderOptions initialization
  MainDataProviderOptions({
    this.mockUpOptions,
    this.httpClientOptions,
    this.sqLiteOptions,
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
  }
}

enum MainDataProviderSourceState {
  UnAvailable,
  Ready,
  Connecting,
}

abstract class AbstractSource {
  ValueNotifier<MainDataProviderSourceState> state = ValueNotifier(MainDataProviderSourceState.UnAvailable);

  final List<MainDataSource> _dataSources = <MainDataSource>[];
  final List<String> _identifiers = <String>[];
  final Map<String, DataRequest> _identifierRequests = Map();

  /// Register the DataSource for data
  registerDataSource(MainDataSource dataSource);

  /// Register DataSource DataRequests for identifiers and example DataRequests mapping
  @protected
  registerDataRequests(MainDataSource dataSource) {
    dataSource.identifiers.forEach((identifier) {
      if (!_identifiers.contains(identifier)) {
        _identifiers.add(identifier);

        _identifierRequests[identifier] = dataSource.requestForIdentifier(identifier)!;
      }
    });
  }

  /// UnRegister the DataSource from receiving data
  unRegisterDataSource(MainDataSource dataSource);

  /// UnRegister DataSource DataRequests for identifiers if no other DataSource has equal
  @protected
  unRegisterDataRequests(MainDataSource dataSource) {
    dataSource.identifiers.forEach((identifier) {
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

  /// Execute one time DataTask against any source
  Future<Map<String, dynamic>> executeDataTask(DataTask dataTask);
}

class MockUpOptions {}

class MockUpSource extends AbstractSource {
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

  /// Execute one time DataTask against any source
  @override
  Future<Map<String, dynamic>> executeDataTask(DataTask dataTask) {
    throw Exception('MockUpSource is not implemented');
  }
}

class HTTPClientOptions {
  final String hostUrl;

  /// HTTPClientOptions initialization
  HTTPClientOptions({
    required this.hostUrl,
  }) : assert(hostUrl.isNotEmpty);
}

class HTTPSource extends AbstractSource {
  final HTTPClientOptions _options;

  /// HTTPSource initialization
  HTTPSource({
    required HTTPClientOptions options,
  }) : _options = options;

  /// Register the DataSource for data
  @override
  registerDataSource(MainDataSource dataSource) {
    throw Exception('HTTPSource is not implemented');
  }

  /// UnRegister the DataSource from receiving data
  @override
  unRegisterDataSource(MainDataSource dataSource) {
    throw Exception('HTTPSource is not implemented');
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

  /// Execute one time DataTask against any source
  @override
  Future<Map<String, dynamic>> executeDataTask(DataTask dataTask) {
    throw Exception('HTTPSource is not implemented');
  }
}

class SQLiteOptions {
  final String databasePath;
  final int version;
  final OnDatabaseCreateFn onCreate;

  /// SQLiteOptions initialization
  SQLiteOptions({
    required this.databasePath,
    required this.version,
    required this.onCreate,
  });
}

class SQLiteSource extends AbstractSource {
  final SQLiteOptions _options;
  Database? _database;

  /// SQLiteSource initialization
  SQLiteSource({
    required SQLiteOptions options,
  }) : _options = options {
    state = ValueNotifier(MainDataProviderSourceState.Ready);
  }

  /// Create Database connection and init tables structure
  Future<Database> _open() async {
    Database? database = _database;

    if (database == null) {
      database = await openDatabase(
        _options.databasePath,
        version: _options.version,
        onCreate: _options.onCreate,
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

    reFetchData(identifiers: dataSource.identifiers);
  }

  /// UnRegister the DataSource from receiving data
  @override
  unRegisterDataSource(MainDataSource dataSource) {
    unRegisterDataRequests(dataSource);

    _dataSources.remove(dataSource);
  }

  /// ReFetch data for DataRequest based on methods or identifiers
  Future<void> reFetchData({List<String>? methods, List<String>? identifiers}) async {
    if (methods == null && identifiers == null) {
      throw Exception('Provide either methods or identifiers');
    }

    if (methods != null) {
      final List<String> identifiers = List.empty(growable: true);

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

  /// Execute one time DataTask against any source
  @override
  Future<Map<String, dynamic>> executeDataTask(DataTask dataTask) {
    throw Exception('SQLiteSource is not implemented');
  }
}