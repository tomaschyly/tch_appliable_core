import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:tch_appliable_core/src/model/data_model.dart';
import 'package:tch_appliable_core/utils/debouncer.dart';

class SembastApiClient {
  final SembastApiOptions options;
  Database? _database;
  final List<SembastApiSubscription> _subscriptions = [];
  final Map<String, Debouncer> _brodcastDebouncers = {};

  Future<Database> get database async {
    if (_database == null) {
      await _init();
    }

    return _database!;
  }

  /// SembastApiClient initialization
  SembastApiClient({
    required this.options,
  });

  /// Manually dispose of resources
  void dispose() {
    _brodcastDebouncers.values.forEach((element) => element.dispose());

    _database?.close();
    _database = null;
  }

  /// Initialize database
  Future<void> _init() async {
    if (_database != null) {
      return;
    }

    _database = await databaseFactoryIo.openDatabase(
      await options.databasePath(),
      version: options.version,
      onVersionChanged: options.onVersionChanged,
    );
  }

  /// Query data from database
  Future<T?> query<T extends DataModel>(
    String storeName,
    T Function(Map<String, Object?>, int id) mapper, {
    Finder? finder,
    List<Filter>? parameters,
    int? findByKey,
  }) async {
    assert(finder == null || parameters == null || findByKey == null, 'Only one of finder, parameters or findByKey can be used');

    final store = intMapStoreFactory.store(storeName);

    if (parameters != null) {
      finder = Finder(filter: Filter.and(parameters));
    }

    if (findByKey != null) {
      finder = Finder(filter: Filter.byKey(findByKey));
    }

    final recordSnapshot = await store.findFirst(await database, finder: finder);

    if (recordSnapshot == null) {
      return null;
    }

    return mapper(recordSnapshot.value, recordSnapshot.key);
  }

  /// Query data from database
  Future<List<T>> queryAll<T extends DataModel>(
    String storeName,
    T Function(Map<String, Object?>, int id) mapper, {
    Finder? finder,
    List<Filter>? parameters,
  }) async {
    assert(finder == null || parameters == null, 'Only one of finder or parameters can be used');

    final store = intMapStoreFactory.store(storeName);

    if (parameters != null) {
      finder = Finder(filter: Filter.and(parameters));
    }

    final recordSnapshot = await store.find(await database, finder: finder);

    return recordSnapshot.map((e) => mapper(e.value, e.key)).toList();
  }

  /// Save data to database
  Future<int> save<T extends DataModel>(
    String storeName,
    T data, {
    int? key,
  }) async {
    final store = intMapStoreFactory.store(storeName);

    final theData = data.toJson();

    if (key == null && theData.containsKey(options.defaultIdKey)) {
      key = theData[options.defaultIdKey] as int?;
    }

    int newKey;

    if (key != null) {
      await store.update(await database, theData, finder: Finder(filter: Filter.byKey(key)));

      newKey = key;
    } else {
      newKey = await store.add(await database, theData);
    }

    final debouncer = _brodcastDebouncers[storeName] ??= Debouncer(milliseconds: kThemeAnimationDuration.inMilliseconds);

    debouncer.run(() {
      _sendDataToSubscriptions(storeName);
    });

    return newKey;
  }

  /// Save data to database
  Future<void> saveAll<T extends DataModel>(String storeName, List<T> data) async {
    final store = intMapStoreFactory.store(storeName);

    final db = await database;

    await db.transaction((txn) async {
      for (final item in data) {
        final theData = item.toJson();

        if (theData.containsKey(options.defaultIdKey)) {
          await store.update(txn, theData, finder: Finder(filter: Filter.byKey(theData[options.defaultIdKey] as int)));
        } else {
          await store.add(txn, theData);
        }
      }
    });

    final debouncer = _brodcastDebouncers[storeName] ??= Debouncer(milliseconds: kThemeAnimationDuration.inMilliseconds);

    debouncer.run(() {
      _sendDataToSubscriptions(storeName);
    });
  }

  /// Delete data from database
  Future<void> delete<T extends DataModel>(
    String storeName,
    T data, {
    int? key,
  }) async {
    final store = intMapStoreFactory.store(storeName);

    key ??= data.toJson()[options.defaultIdKey] as int?;

    if (key != null) {
      await store.delete(await database, finder: Finder(filter: Filter.byKey(key)));
    }

    final debouncer = _brodcastDebouncers[storeName] ??= Debouncer(milliseconds: kThemeAnimationDuration.inMilliseconds);

    debouncer.run(() {
      _sendDataToSubscriptions(storeName);
    });
  }

  /// Delete data from database
  Future<void> deleteAll<T extends DataModel>(String storeName, List<T> data) async {
    final store = intMapStoreFactory.store(storeName);

    final db = await database;

    await db.transaction((txn) async {
      for (final item in data) {
        final theData = item.toJson();

        if (theData.containsKey(options.defaultIdKey)) {
          await store.delete(txn, finder: Finder(filter: Filter.byKey(theData[options.defaultIdKey] as int)));
        }
      }
    });

    final debouncer = _brodcastDebouncers[storeName] ??= Debouncer(milliseconds: kThemeAnimationDuration.inMilliseconds);

    debouncer.run(() {
      _sendDataToSubscriptions(storeName);
    });
  }

  /// Create and save subscription
  SembastApiSubscription<T> subscribe<T extends DataModel>(
    String storeName,
    void Function(List<T> data) onData,
    T Function(Map<String, Object?>, int id) mapper, {
    Finder? finder,
    List<Filter>? parameters,
  }) {
    final subscription = SembastApiSubscription(
      subscriptions: _subscriptions,
      storeName: storeName,
      finder: finder,
      parameters: parameters,
      mapper: mapper,
      onData: onData,
    );

    _subscriptions.add(subscription);

    final debouncer = _brodcastDebouncers[storeName] ??= Debouncer(milliseconds: kThemeAnimationDuration.inMilliseconds);

    debouncer.run(() {
      _sendDataToSubscriptions(storeName);
    });

    return subscription;
  }

  /// Send data to all subscriptions matching storeName
  Future<void> _sendDataToSubscriptions(String storeName) async {
    final subscriptions = [..._subscriptions].where((element) => element.storeName == storeName);

    for (final subscription in subscriptions) {
      final store = intMapStoreFactory.store(storeName);

      Finder? finder = subscription.finder;

      if (subscription.parameters != null) {
        finder = Finder(filter: Filter.and(subscription.parameters!));
      }

      final recordSnapshot = await store.find(await database, finder: finder);

      subscription.parseSendData(recordSnapshot);
    }
  }
}

class SembastApiOptions {
  final Future<String> Function() databasePath;
  final int version;
  final OnVersionChangedFunction? onVersionChanged;
  final String defaultIdKey;

  /// SembastApiOptions initialization
  SembastApiOptions({
    required this.databasePath,
    this.version = 1,
    this.onVersionChanged,
    this.defaultIdKey = 'id',
  });
}

class SembastApiSubscription<T> {
  final List<SembastApiSubscription> subscriptions;
  final String storeName;
  final Finder? finder;
  final List<Filter>? parameters;
  final T Function(Map<String, Object?>, int id) mapper;
  final void Function(List<T> data) onData;

  /// SembastApiSubscription initialization
  SembastApiSubscription({
    required this.subscriptions,
    required this.storeName,
    this.finder,
    this.parameters,
    required this.mapper,
    required this.onData,
  });

  /// Cancel subscription
  void cancel() {
    subscriptions.remove(this);
  }

  /// Parse data from database and send to onData callback
  void parseSendData(List<RecordSnapshot<int, Map<String, Object?>>> recordSnapshot) {
    onData(recordSnapshot.map((e) => mapper(e.value, e.key)).toList());
  }
}

class SembastApiProvider extends InheritedWidget {
  final SembastApiClient apiClient;

  /// SembastApiProvider
  SembastApiProvider({
    required Widget child,
    required this.apiClient,
  }) : super(child: child);

  /// SembastApiProvider access current apiClient anywhere from BuildContext
  static SembastApiClient? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SembastApiProvider>()?.apiClient;
  }

  /// Disable update notifications
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

extension SembastApiProviderExtension on BuildContext {
  /// SembastApiProvider access current apiClient anywhere from BuildContext
  SembastApiClient get sembastApiClient => SembastApiProvider.of(this)!;
}
