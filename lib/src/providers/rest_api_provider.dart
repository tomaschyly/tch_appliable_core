import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:supercharged/supercharged.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';
import 'package:tch_appliable_core/utils/debouncer.dart';
import 'package:uuid/uuid.dart';

class RestApiClient {
  final RestApiOptions options;
  final Map<String, dynamic> _cache = <String, dynamic>{};
  final List<RestApiSubscription> _subscriptions = <RestApiSubscription>[];
  final Map<String, Debouncer> _brodcastDebouncersByTopic = <String, Debouncer>{};
  final Map<String, Debouncer> _brodcastDebouncersByIdentifier = <String, Debouncer>{};
  final List<String> _allTopicsOfSubscriptions = <String>[];
  Timer? _pollSubscriptionsTimer;

  /// RestApiClient initialization
  RestApiClient({
    required this.options,
  }) {
    _pollSubscriptionsTimer = Timer.periodic(options.pollSubscriptionsInterval, (timer) {
      final allTopicsOfSubscriptions = _allTopicsOfSubscriptions.toSet().toList();

      allTopicsOfSubscriptions.forEach((topic) {
        getDataForSubscriptions(topic);
      });
    });
  }

  /// Manually dispose of resources
  void dispose() {
    _pollSubscriptionsTimer?.cancel();

    _subscriptions.forEach((subscription) {
      subscription.cancel.call();
    });
    _subscriptions.clear();
    options.onSubscriptionsChange?.call(_subscriptions);

    _brodcastDebouncersByTopic.forEach((key, value) {
      value.dispose();
    });

    _brodcastDebouncersByIdentifier.forEach((key, value) {
      value.dispose();
    });
  }

  /// Create default request headers
  Future<Map<String, String>> _createDefaultHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (options.headers != null) {
      headers.addAll(await options.headers!());
    }

    return headers;
  }

  /// Create identifier from topic and parameters
  String _createIdentifier(String type, String uri, Map<String, dynamic> params) {
    final paramsString = jsonEncode(params);

    return '$type#$uri#$paramsString';
  }

  /// Get data from cache for identifier
  dynamic _getFromCache(String identifier) {
    return _cache[identifier];
  }

  /// Set data to cache for identifier
  void _setToCache(String identifier, dynamic data) {
    _cache[identifier] = data;
  }

  /// Build GET URI with baseUri and parameters
  String restUriBuilder(String uri, [Map<String, String>? parameters]) {
    final uriWithParameters = parameters != null ? '$uri?${parameters.entries.map((e) => '${e.key}=${e.value}').join('&')}' : uri;

    return options.baseUri + uriWithParameters;
  }

  /// REST API GET request
  /// Using dio for better functionality
  Future<CancelToken?> get(RestApiParams params) async {
    final identifier = _createIdentifier('GET', params.uri, params.params ?? {});
    final fetchPolicy = params.fetchPolicy ?? options.fetchPolicy;

    if (fetchPolicy == FetchPolicy.cacheAndNetwork || fetchPolicy == FetchPolicy.cacheOnly) {
      final data = _getFromCache(identifier);

      if (data != null || fetchPolicy == FetchPolicy.cacheOnly) {
        params.onData(data);
      }
    }

    if (fetchPolicy == FetchPolicy.cacheAndNetwork || fetchPolicy == FetchPolicy.networkOnly) {
      params.setLoading?.call(true);

      final cancelToken = CancelToken();

      Dio()
          .get<String>(
        '${options.baseUri}${params.uri}',
        options: Options(
          headers: {
            ...(await _createDefaultHeaders()),
            ...(params.headers ?? {}),
          },
        ),
        queryParameters: params.params,
        cancelToken: cancelToken, //TODO verify paramsSerializer is needed?
      )
          .then((response) {
        params.setLoading?.call(false);

        if (response.statusCode != 200) {
          throw Exception('RestApiClient.get: ${response.statusCode} - ${response.statusMessage}');
        }

        _setToCache(identifier, response.data);

        params.onData(response.data);
      }).catchError((error) {
        params.setLoading?.call(false);

        debugPrint('RestApiClient.get: $error');
        debugPrintStack(stackTrace: error.stackTrace ?? StackTrace.current);

        _setToCache(identifier, null);
        params.onData(null);

        params.onError?.call(error);
      });

      return cancelToken;
    }

    return null;
  }

  /// REST API POST request
  /// Using dio for better functionality
  Future<CancelToken?> post(RestApiParams params) async {
    final identifier = _createIdentifier('POST', params.uri, params.params ?? {});
    final fetchPolicy = params.fetchPolicy ?? options.fetchPolicy;

    if (fetchPolicy == FetchPolicy.cacheAndNetwork || fetchPolicy == FetchPolicy.cacheOnly) {
      final data = _getFromCache(identifier);

      if (data != null || fetchPolicy == FetchPolicy.cacheOnly) {
        params.onData(data);
      }
    }

    if (fetchPolicy == FetchPolicy.cacheAndNetwork || fetchPolicy == FetchPolicy.networkOnly) {
      params.setLoading?.call(true);

      final cancelToken = CancelToken();

      Dio()
          .post<String>(
        '${options.baseUri}${params.uri}',
        options: Options(
          headers: {
            ...(await _createDefaultHeaders()),
            ...(params.headers ?? {}),
          },
        ),
        data: params.params,
        cancelToken: cancelToken,
      )
          .then((response) {
        params.setLoading?.call(false);

        if (response.statusCode != 200) {
          throw Exception('RestApiClient.post: ${response.statusCode} - ${response.statusMessage}');
        }

        _setToCache(identifier, response.data);

        params.onData(response.data);
      }).catchError((error) {
        params.setLoading?.call(false);

        debugPrint('RestApiClient.post: $error');
        debugPrintStack(stackTrace: error.stackTrace ?? StackTrace.current);

        _setToCache(identifier, null);
        params.onData(null);

        params.onError?.call(error);
      });

      return cancelToken;
    }

    return null;
  }

  /// REST API DELETE request
  /// Using dio for better functionality
  Future<CancelToken?> delete(RestApiParams params) async {
    final identifier = _createIdentifier('DELETE', params.uri, params.params ?? {});
    final fetchPolicy = params.fetchPolicy ?? options.fetchPolicy;

    if (fetchPolicy == FetchPolicy.cacheAndNetwork || fetchPolicy == FetchPolicy.cacheOnly) {
      final data = _getFromCache(identifier);

      if (data != null || fetchPolicy == FetchPolicy.cacheOnly) {
        params.onData(data);
      }
    }

    if (fetchPolicy == FetchPolicy.cacheAndNetwork || fetchPolicy == FetchPolicy.networkOnly) {
      params.setLoading?.call(true);

      final cancelToken = CancelToken();

      Dio()
          .delete<String>(
        '${options.baseUri}${params.uri}',
        options: Options(
          headers: {
            ...(await _createDefaultHeaders()),
            ...(params.headers ?? {}),
          },
        ),
        queryParameters: params.params,
        cancelToken: cancelToken,
      )
          .then((response) {
        params.setLoading?.call(false);

        if (response.statusCode != 200) {
          throw Exception('RestApiClient.delete: ${response.statusCode} - ${response.statusMessage}');
        }

        _setToCache(identifier, response.data);

        params.onData(response.data);
      }).catchError((error) {
        params.setLoading?.call(false);

        debugPrint('RestApiClient.delete: $error');
        debugPrintStack(stackTrace: error.stackTrace ?? StackTrace.current);

        _setToCache(identifier, null);
        params.onData(null);

        params.onError?.call(error);
      });

      return cancelToken;
    }

    return null;
  }

  /// Get Subscriptions by topic
  /// Group by identifier
  /// Call getData on each group
  /// Send the data or error to subscriptions in group
  void getDataForSubscriptions(String topic) {
    final subscriptionsByTopic = _subscriptions.where((subscription) => subscription.topic == topic).toList();

    final subscriptionsByIdentifier = <FetchPolicy, Map<String, List<RestApiSubscription>>>{
      FetchPolicy.none: <String, List<RestApiSubscription>>{},
      FetchPolicy.cacheAndNetwork: <String, List<RestApiSubscription>>{},
      FetchPolicy.networkOnly: <String, List<RestApiSubscription>>{},
      FetchPolicy.cacheOnly: <String, List<RestApiSubscription>>{},
    };

    subscriptionsByTopic.forEach((subscription) {
      final fetchPolicy = subscription.params.fetchPolicy ?? options.fetchPolicy;

      if (!subscriptionsByIdentifier[fetchPolicy]!.containsKey(subscription.identifier)) {
        subscriptionsByIdentifier[fetchPolicy]![subscription.identifier] = <RestApiSubscription>[];
      }

      subscriptionsByIdentifier[fetchPolicy]![subscription.identifier]!.add(subscription);
    });

    for (final fetchPolicyIn in subscriptionsByIdentifier.keys) {
      final subscriptions = subscriptionsByIdentifier[fetchPolicyIn]!;

      for (final identifier in subscriptions.keys) {
        final subscription = subscriptions[identifier]!.first;

        if (fetchPolicyIn == FetchPolicy.cacheAndNetwork || fetchPolicyIn == FetchPolicy.cacheOnly) {
          final data = _getFromCache(identifier);

          if (data != null || fetchPolicyIn == FetchPolicy.cacheOnly) {
            subscriptions[identifier]!.forEach((subscription) {
              subscription.params.onData(data);
            });
          }
        }

        if (fetchPolicyIn == FetchPolicy.cacheAndNetwork || fetchPolicyIn == FetchPolicy.networkOnly) {
          final debouncer = _brodcastDebouncersByTopic[identifier] ??= Debouncer(milliseconds: kThemeAnimationDuration.inMilliseconds);

          debouncer.run(() {
            get(
              subscription.params.copyWith(
                fetchPolicy: fetchPolicyIn,
                setLoading: (loading) {
                  subscriptions[identifier]!.forEach((subscription) {
                    subscription.params.setLoading?.call(loading);
                  });
                },
                onData: (data) {
                  subscriptions[identifier]!.forEach((subscription) {
                    subscription.params.onData(data);
                  });
                },
                onError: (error) {
                  subscriptions[identifier]!.forEach((subscription) {
                    subscription.params.onError?.call(error);
                  });
                },
              ),
            );
          });
        }
      }
    }
  }

  /// Get Subscriptions by identifier
  /// Group by identifier
  /// Call getData on each group
  /// Send the data or error to subscriptions in group
  void getDataForSubscriptionsByIdentifier(String identifier) {
    final subscriptionsByIdentifier = _subscriptions.where((subscription) => subscription.identifier == identifier).toList();

    final subscriptionsByFetchPolicy = <FetchPolicy, Map<String, List<RestApiSubscription>>>{
      FetchPolicy.none: <String, List<RestApiSubscription>>{},
      FetchPolicy.cacheAndNetwork: <String, List<RestApiSubscription>>{},
      FetchPolicy.networkOnly: <String, List<RestApiSubscription>>{},
      FetchPolicy.cacheOnly: <String, List<RestApiSubscription>>{},
    };

    subscriptionsByIdentifier.forEach((subscription) {
      final fetchPolicy = subscription.params.fetchPolicy ?? options.fetchPolicy;

      if (!subscriptionsByFetchPolicy[fetchPolicy]!.containsKey(subscription.identifier)) {
        subscriptionsByFetchPolicy[fetchPolicy]![subscription.identifier] = <RestApiSubscription>[];
      }

      subscriptionsByFetchPolicy[fetchPolicy]![subscription.identifier]!.add(subscription);
    });

    for (final fetchPolicyIn in subscriptionsByFetchPolicy.keys) {
      final subscriptions = subscriptionsByFetchPolicy[fetchPolicyIn]!;

      for (final identifier in subscriptions.keys) {
        final subscription = subscriptions[identifier]!.first;

        if (fetchPolicyIn == FetchPolicy.cacheAndNetwork || fetchPolicyIn == FetchPolicy.cacheOnly) {
          final data = _getFromCache(identifier);

          if (data != null || fetchPolicyIn == FetchPolicy.cacheOnly) {
            subscriptions[identifier]!.forEach((subscription) {
              subscription.params.onData(data);
            });
          }
        }

        if (fetchPolicyIn == FetchPolicy.cacheAndNetwork || fetchPolicyIn == FetchPolicy.networkOnly) {
          final debouncer = _brodcastDebouncersByIdentifier[identifier] ??= Debouncer(milliseconds: kThemeAnimationDuration.inMilliseconds);

          debouncer.run(() {
            get(
              subscription.params.copyWith(
                fetchPolicy: fetchPolicyIn,
                setLoading: (loading) {
                  subscriptions[identifier]!.forEach((subscription) {
                    subscription.params.setLoading?.call(loading);
                  });
                },
                onData: (data) {
                  subscriptions[identifier]!.forEach((subscription) {
                    subscription.params.onData(data);
                  });
                },
                onError: (error) {
                  subscriptions[identifier]!.forEach((subscription) {
                    subscription.params.onError?.call(error);
                  });
                },
              ),
            );
          });
        }
      }
    }
  }

  /// Update topics of subscriptions
  void _updateTopicsOfSubscriptions() {
    _allTopicsOfSubscriptions.clear();

    _subscriptions.forEach((subscription) {
      _allTopicsOfSubscriptions.add(subscription.topic);
    });
  }

  /// Create and save subscription
  /// Create Debouncer for identifier if not exists
  RestApiSubscription subscribe(
    String topic,
    RestApiParams params,
    bool Function(List<dynamic> notifications) validateEvent,
  ) {
    final identifier = _createIdentifier('GET', params.uri, params.params ?? {});

    final uuid = const Uuid().v4();

    final subscription = RestApiSubscription(
      uuid: uuid,
      topic: topic,
      identifier: identifier,
      params: params,
      cancel: () {
        _subscriptions.removeWhere((element) => element.uuid == uuid);

        _updateTopicsOfSubscriptions();

        options.onSubscriptionsChange?.call(_subscriptions);
      },
      validateEvent: validateEvent,
    );

    _subscriptions.add(subscription);

    _updateTopicsOfSubscriptions();

    options.onSubscriptionsChange?.call(_subscriptions);

    Future.delayed(1.milliseconds, () {
      getDataForSubscriptions(topic);
    });

    return subscription;
  }
}

enum FetchPolicy {
  none,
  cacheAndNetwork,
  networkOnly,
  cacheOnly,
}

class RestApiOptions {
  final RestApiHeaders? headers;
  final String baseUri;
  final FetchPolicy fetchPolicy;
  final Duration pollSubscriptionsInterval;
  final ValueChanged<List<RestApiSubscription>>? onSubscriptionsChange;

  /// RestApiOptions initialization
  RestApiOptions({
    this.headers,
    required this.baseUri,
    this.fetchPolicy = FetchPolicy.cacheAndNetwork,
    this.pollSubscriptionsInterval = const Duration(minutes: 30),
    this.onSubscriptionsChange,
  });
}

typedef RestApiHeaders = Future<Map<String, String>> Function();

class RestApiParams {
  final String uri;
  final Map<String, String>? headers;
  final Map<String, dynamic>? params;
  final FetchPolicy? fetchPolicy;
  final void Function(bool loading)? setLoading;
  final void Function(dynamic data) onData;
  final void Function(dynamic error)? onError;

  /// RestApiParams initialization
  RestApiParams({
    required this.uri,
    this.headers,
    this.params,
    this.fetchPolicy,
    this.setLoading,
    required this.onData,
    this.onError,
  });

  /// Copy RestApiSubscription with new parameters
  RestApiParams copyWith({
    String? uri,
    Map<String, String>? headers,
    Map<String, dynamic>? params,
    FetchPolicy? fetchPolicy,
    void Function(bool loading)? setLoading,
    void Function(dynamic data)? onData,
    void Function(dynamic error)? onError,
  }) {
    return RestApiParams(
      uri: uri ?? this.uri,
      headers: headers ?? this.headers,
      params: params ?? this.params,
      fetchPolicy: fetchPolicy ?? this.fetchPolicy,
      setLoading: setLoading ?? this.setLoading,
      onData: onData ?? this.onData,
      onError: onError ?? this.onError,
    );
  }
}

class RestApiSubscription {
  final String uuid;
  final String topic;
  final String identifier;
  final RestApiParams params;
  final VoidCallback cancel;
  final bool Function(List<dynamic> notifications) validateEvent;

  /// RestApiSubscription initialization
  RestApiSubscription({
    required this.uuid,
    required this.topic,
    required this.identifier,
    required this.params,
    required this.cancel,
    required this.validateEvent,
  });

  /// Copy RestApiSubscription with new parameters
  RestApiSubscription copyWith({
    String? uuid,
    String? topic,
    String? identifier,
    RestApiParams? params,
    VoidCallback? cancel,
    bool Function(List<dynamic> notifications)? validateEvent,
  }) {
    return RestApiSubscription(
      uuid: uuid ?? this.uuid,
      topic: topic ?? this.topic,
      identifier: identifier ?? this.identifier,
      params: params ?? this.params,
      cancel: cancel ?? this.cancel,
      validateEvent: validateEvent ?? this.validateEvent,
    );
  }
}

class RestApiProvider extends InheritedWidget {
  final RestApiClient apiClient;

  /// RestApiProvider initialization
  RestApiProvider({
    required this.apiClient,
    required Widget child,
  }) : super(child: child);

  /// Get the closest instance of RestApiClient class from the build context
  static RestApiClient? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RestApiProvider>()?.apiClient;
  }

  /// Disable update should notify
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

extension RestApiProviderExtension on BuildContext {
  /// Get the closest instance of RestApiClient class from the build context
  RestApiClient get restApiClient => RestApiProvider.of(this)!;
}
