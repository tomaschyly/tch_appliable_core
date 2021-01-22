import 'package:shared_preferences/shared_preferences.dart';

/// Int values, it is for init, defaults and in memory storage
final Map<String, int> intPrefs = {};

/// Double values, it is for init, defaults and in memory storage
final Map<String, double> doublePrefs = {};

/// String values, it is for init, defaults and in memory storage
final Map<String, String> stringPrefs = {};

/// Shorthand for int value from prefs
int? prefsInt(String key) => Preferences.instance?.getInt(key);

/// Shorthand for double value from prefs
double? prefsDouble(String key) => Preferences.instance?.getDouble(key);

/// Shorthand for string value from prefs
String? prefsString(String key) => Preferences.instance?.getString(key);

/// Shorthand to save int value to prefs
Future<bool> prefsSetInt(String key, int value) => Preferences.instance?.setInt(key, value) ?? Future.value(false);

/// Shorthand to save double value to prefs
Future<bool> prefsSetDouble(String key, double value) => Preferences.instance?.setDouble(key, value) ?? Future.value(false);

/// Shorthand to save string value to prefs
Future<bool> prefsSetString(String key, String value) => Preferences.instance?.setString(key, value) ?? Future.value(false);

class PreferencesOptions {
  final Map<String, int>? intPrefs;
  final Map<String, double>? doublePrefs;
  final Map<String, String>? stringPrefs;

  /// PreferencesOptions initialization
  PreferencesOptions({
    this.intPrefs,
    this.doublePrefs,
    this.stringPrefs,
  });
}

class Preferences {
  static Preferences? get instance => _instance;

  static Preferences? _instance;

  final PreferencesOptions _options;
  SharedPreferences? _prefs;

  /// Preferences initialization
  Preferences({
    required PreferencesOptions options,
  }) : _options = options {
    _instance = this;
  }

  /// Initialize preferences from their storage
  Future init() async {
    _prefs = await SharedPreferences.getInstance();

    final theOptionsIntPrefs = _options.intPrefs;
    if (theOptionsIntPrefs != null) {
      for (String key in theOptionsIntPrefs.keys) {
        intPrefs[key] = _prefs?.getInt(key) ?? theOptionsIntPrefs[key]!;
      }
    }

    final theOptionsDoublePrefs = _options.doublePrefs;
    if (theOptionsDoublePrefs != null) {
      for (String key in theOptionsDoublePrefs.keys) {
        doublePrefs[key] = _prefs?.getDouble(key) ?? theOptionsDoublePrefs[key]!;
      }
    }

    final theOptionsStringPrefs = _options.stringPrefs;
    if (theOptionsStringPrefs != null) {
      for (String key in theOptionsStringPrefs.keys) {
        stringPrefs[key] = _prefs?.getString(key) ?? theOptionsStringPrefs[key]!;
      }
    }
  }

  /// Get int value for key from prefs
  int? getInt(String key) {
    return intPrefs[key] ?? _prefs?.getInt(key);
  }

  /// Get double value for key from prefs
  double? getDouble(String key) {
    return doublePrefs[key] ?? _prefs?.getDouble(key);
  }

  /// Get string value for key from prefs
  String? getString(String key) {
    return stringPrefs[key] ?? _prefs?.getString(key);
  }

  /// Set int value for key to prefs
  Future<bool> setInt(String key, int value) {
    intPrefs[key] = value;

    return _prefs?.setInt(key, value) ?? Future.value(false);
  }

  /// Set double value for key to prefs
  Future<bool> setDouble(String key, double value) {
    doublePrefs[key] = value;

    return _prefs?.setDouble(key, value) ?? Future.value(false);
  }

  /// Set string value for key to prefs
  Future<bool> setString(String key, String value) {
    stringPrefs[key] = value;

    return _prefs?.setString(key, value) ?? Future.value(false);
  }
}
