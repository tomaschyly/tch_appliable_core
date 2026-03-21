import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';

class TranslatorOptions {
  final List<String> languages;
  final List<Locale> supportedLocales;
  final Future<String?> Function(BuildContext context)? getInitialLanguage;
  ValueChanged<Locale>? onLanguageChange;

  /// TranslatorOptions initialization
  TranslatorOptions({
    required this.languages,
    required this.supportedLocales,
    this.getInitialLanguage,
    this.onLanguageChange,
  })  : assert(languages.isNotEmpty),
        assert(languages.length == supportedLocales.length);
}

/// Shorthand to translate string to current Language
String tt(String text, {Map<String, String>? parameters}) => Translator.instance?.translate(text, parameters: parameters) ?? text;

class Translator {
  static Translator? get instance => _instance;

  static Translator? _instance;

  String get currentLanguage => _currentLanguage;
  List<String> get languages => _options.languages;

  final HtmlUnescape _htmlUnescape = HtmlUnescape();
  final TranslatorOptions _options;
  String _currentLanguage = 'en';
  Map<String, String> _currentTranslations = {};

  /// Translator initialization
  Translator({
    required TranslatorOptions options,
  }) : _options = options {
    _instance = this;
  }

  /// Initialize correct Language and translations for it
  Future<void> init(BuildContext context) async {
    final theGetInitialLanguage = _options.getInitialLanguage;
    if (theGetInitialLanguage != null) {
      final String? initialLanguage = await theGetInitialLanguage(context);

      if (initialLanguage != null) {
        _currentLanguage = langSupported(initialLanguage);

        await initTranslations();

        return;
      }
    }

    final Locale locale = Localizations.localeOf(context);
    final String fullCode = '${locale.languageCode}_${locale.countryCode}';

    final hasCodeWithCountry = langSupportedStrict(fullCode);

    if (hasCodeWithCountry) {
      _currentLanguage = fullCode;
    } else {
      _currentLanguage = langSupported(locale.languageCode);
    }

    await initTranslations();
  }

  /// Check if language code is supported in options, fallback to first supported language
  String langSupported(String languageCode) {
    return languages.contains(languageCode) ? languageCode : languages.first;
  }

  /// Check if language code is supported in options, no fallback
  bool langSupportedStrict(String languageCode) {
    return languages.contains(languageCode);
  }

  /// Initialize translations for current or given language from assets JSON file
  Future<void> initTranslations([String? language]) async {
    if (language != null) {
      _currentLanguage = langSupported(language);
    }

    if (!languages.contains(_currentLanguage)) {
      throw Exception('Translator cannot initialize unsupported language');
    }

    final String json = await rootBundle.loadString('assets/translations/$_currentLanguage.json');

    _currentTranslations = Map<String, String>.from(jsonDecode(json));

    _options.onLanguageChange?.call(Locale(_currentLanguage));
  }

  /// Translate string to current Language
  String translate(String text, {Map<String, String>? parameters}) {
    String translated = _currentTranslations[text] != null ? _htmlUnescape.convert(_currentTranslations[text]!) : text;

    if (parameters != null) {
      for (String key in parameters.keys) {
        translated = translated.replaceAll(key, parameters[key]!);
      }
    }

    return translated;
  }

  /// Change to new Language, reload translations and notify locale change.
  /// This replaces the old two-step pattern of calling changeLanguage() + initTranslations(context).
  /// Migration: remove the initTranslations() call that followed changeLanguage() — it is now done internally.
  Future<void> changeLanguage(String language) async {
    _currentLanguage = langSupported(language);

    await initTranslations();
  }

  /// Default DateFormat localized to current Language
  DateFormat get localizedDateTimeFormat => DateFormat.yMMMMEEEEd(_currentLanguage).add_jm();

  /// Default DateFormat localized to current Language
  DateFormat get localizedDateFormat => DateFormat.yMMMMEEEEd(_currentLanguage);
}

extension TranslationStringExtension on String {
  /// Translate the string using Translator instance
  String tt({Map<String, String>? parameters}) {
    return Translator.instance?.translate(this, parameters: parameters) ?? this;
  }

  /// Apply translation parameters on string
  String parameters(Map<String, String> parameters) {
    String translated = this;

    for (String key in parameters.keys) {
      translated = translated.replaceAll(key, parameters[key]!);
    }

    return translated;
  }
}

extension MaterialLocalizationsExtension on MaterialLocalizations {
  /// Get firstDayOfWeekIndex, but in 1-7 range
  int get firstDayOfWeekForOneToSeven {
    return firstDayOfWeekIndex == 0 ? 7 : firstDayOfWeekIndex;
  }
}
