import 'package:shared_preferences/shared_preferences.dart';

/// Shorthand for int value from prefs
int? prefsInt(String key) => Preferences.instance?.getInt(key);

/// Shorthand for double value from prefs
double? prefsDouble(String key) => Preferences.instance?.getDouble(key);

/// Shorthand for string value from prefs
String? prefsString(String key) => Preferences.instance?.getString(key);

/// Shorthand to save int value to prefs
Future<bool> prefsSetInt(String key, int value) =>
    Preferences.instance?.setInt(key, value) ?? Future.value(false);

/// Shorthand to save double value to prefs
Future<bool> prefsSetDouble(String key, double value) =>
    Preferences.instance?.setDouble(key, value) ?? Future.value(false);

/// Shorthand to save string value to prefs
Future<bool> prefsSetString(String key, String value) =>
    Preferences.instance?.setString(key, value) ?? Future.value(false);

/// Shorthand to remove int value from prefs
Future<bool> prefsRemoveInt(String key) =>
    Preferences.instance?.removeInt(key) ?? Future.value(false);

/// Shorthand to remove double value from prefs
Future<bool> prefsRemoveDouble(String key) =>
    Preferences.instance?.removeDouble(key) ?? Future.value(false);

/// Shorthand for bool value from prefs
bool? prefsBool(String key) => Preferences.instance?.getBool(key);

/// Shorthand to save bool value to prefs
Future<bool> prefsSetBool(String key, bool value) =>
    Preferences.instance?.setBool(key, value) ?? Future.value(false);

/// Shorthand to remove bool value from prefs
Future<bool> prefsRemoveBool(String key) =>
    Preferences.instance?.removeBool(key) ?? Future.value(false);

/// Shorthand to remove string value from prefs
Future<bool> prefsRemoveString(String key) =>
    Preferences.instance?.removeString(key) ?? Future.value(false);

class PreferencesOptions {
  final Map<String, int>? intPrefs;
  final Map<String, double>? doublePrefs;
  final Map<String, String>? stringPrefs;
  final Map<String, bool>? boolPrefs;

  /// PreferencesOptions initialization
  PreferencesOptions({
    this.intPrefs,
    this.doublePrefs,
    this.stringPrefs,
    this.boolPrefs,
  });
}

class Preferences {
  static Preferences? get instance => _instance;

  static Preferences? _instance;

  final PreferencesOptions _options;
  SharedPreferences? _prefs;
  final Map<String, int> _intPrefs = {};
  final Map<String, double> _doublePrefs = {};
  final Map<String, String> _stringPrefs = {};
  final Map<String, bool> _boolPrefs = {};

  /// Preferences initialization
  Preferences({
    required PreferencesOptions options,
  }) : _options = options {
    _instance = this;
  }

  /// Initialize preferences from their storage
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    final theOptionsIntPrefs = _options.intPrefs;
    if (theOptionsIntPrefs != null) {
      for (String key in theOptionsIntPrefs.keys) {
        _intPrefs[key] = _prefs!.getInt(key) ?? theOptionsIntPrefs[key]!;
      }
    }

    final theOptionsDoublePrefs = _options.doublePrefs;
    if (theOptionsDoublePrefs != null) {
      for (String key in theOptionsDoublePrefs.keys) {
        _doublePrefs[key] =
            _prefs!.getDouble(key) ?? theOptionsDoublePrefs[key]!;
      }
    }

    final theOptionsStringPrefs = _options.stringPrefs;
    if (theOptionsStringPrefs != null) {
      for (String key in theOptionsStringPrefs.keys) {
        _stringPrefs[key] =
            _prefs!.getString(key) ?? theOptionsStringPrefs[key]!;
      }
    }

    final theOptionsBoolPrefs = _options.boolPrefs;
    if (theOptionsBoolPrefs != null) {
      for (String key in theOptionsBoolPrefs.keys) {
        _boolPrefs[key] = _prefs!.getBool(key) ?? theOptionsBoolPrefs[key]!;
      }
    }
  }

  /// Get int value for key from prefs
  int? getInt(String key) {
    return _intPrefs[key] ?? _prefs?.getInt(key);
  }

  /// Get double value for key from prefs
  double? getDouble(String key) {
    return _doublePrefs[key] ?? _prefs?.getDouble(key);
  }

  /// Get string value for key from prefs
  String? getString(String key) {
    return _stringPrefs[key] ?? _prefs?.getString(key);
  }

  /// Get bool value for key from prefs
  bool? getBool(String key) {
    return _boolPrefs[key] ?? _prefs?.getBool(key);
  }

  /// Set int value for key to prefs
  Future<bool> setInt(String key, int value) async {
    _intPrefs[key] = value;

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }

  /// Set double value for key to prefs
  Future<bool> setDouble(String key, double value) async {
    _doublePrefs[key] = value;

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.setDouble(key, value);
  }

  /// Set string value for key to prefs
  Future<bool> setString(String key, String value) async {
    _stringPrefs[key] = value;

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  /// Set bool value for key to prefs
  Future<bool> setBool(String key, bool value) async {
    _boolPrefs[key] = value;

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  /// Remove int value for key
  Future<bool> removeInt(String key) async {
    _intPrefs.remove(key);

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.remove(key);
  }

  /// Remove double value for key
  Future<bool> removeDouble(String key) async {
    _doublePrefs.remove(key);

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.remove(key);
  }

  /// Remove string value for key
  Future<bool> removeString(String key) async {
    _stringPrefs.remove(key);

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.remove(key);
  }

  /// Remove bool value for key
  Future<bool> removeBool(String key) async {
    _boolPrefs.remove(key);

    final prefs = _prefs ?? await SharedPreferences.getInstance();

    return prefs.remove(key);
  }
}
