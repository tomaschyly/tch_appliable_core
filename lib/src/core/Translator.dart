import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:intl/intl.dart';

class TranslatorOptions {
  final List<String> languages;
  final List<Locale> supportedLocales;
  final Future<String?> Function(BuildContext context)? getInitialLanguage;

  /// TranslatorOptions initialization
  TranslatorOptions({
    required this.languages,
    required this.supportedLocales,
    this.getInitialLanguage,
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
  Map<String, String> _currentTranslations = Map();

  /// Translator initialization
  Translator({
    required TranslatorOptions options,
  }) : _options = options {
    _instance = this;
  }

  /// Initialize correct Language and translations for it
  Future init(BuildContext context) async {
    final theGetInitialLanguage = _options.getInitialLanguage;
    if (theGetInitialLanguage != null) {
      final String? initialLanguage = await theGetInitialLanguage(context);

      if (initialLanguage != null) {
        _currentLanguage = langSupported(initialLanguage);

        await initTranslations(context);

        return;
      }
    }

    final Locale? locale = Localizations.localeOf(context);

    _currentLanguage = langSupported(locale?.languageCode ?? '');

    await initTranslations(context);
  }

  /// Check if language code is supported in options, fallback to first supported language
  String langSupported(String languageCode) {
    return languages.contains(languageCode) ? languageCode : languages.first;
  }

  /// Initialize translations for language from assets JSON file
  Future<void> initTranslations(BuildContext context, [String? language]) async {
    final String theLanguage = language ?? _currentLanguage;

    if (!languages.contains(theLanguage)) {
      throw Exception('Translator cannot initialize unsupported language');
    }

    String json = await rootBundle.loadString('assets/translations/$theLanguage.json');

    Map<String, String> translations = Map<String, String>.from(jsonDecode(json));

    _currentTranslations = translations;
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

  /// Change current to new Language if supported in options
  void changeLanguage(String language) {
    if (languages.contains(language)) {
      _currentLanguage = language;
    } else {
      _currentLanguage = languages.first;
    }
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
