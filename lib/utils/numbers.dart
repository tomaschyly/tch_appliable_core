import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Get default locale from BuildContext
Locale platformLocale(BuildContext context) {
  return View.of(context).platformDispatcher.locale;
}

/// If possible convert text value to double number
double? stringToDouble(String? text, [String? languageCode]) {
  if (text == null) return null;

  try {
    final num parsed = NumberFormat.decimalPattern(languageCode).parse(text);

    return parsed.toDouble();
  } catch (e) {
    debugPrint(e.toString());
  }

  return double.tryParse(text);
}

/// Convert double to string respecting decimal symbol by Locale
String doubleToString(double value, [String? languageCode]) {
  try {
    return NumberFormat.decimalPattern(languageCode).format(value);
  } catch (e) {
    debugPrint(e.toString());
  }

  return value.toString();
}

/// Convert double to currency text formatted with decimals
String doubleAsCurrency(double? value, [String? languageCode]) {
  try {
    return NumberFormat.decimalPattern(languageCode).format(value ?? 0.0);
  } catch (e) {
    debugPrint(e.toString());
  }

  return (value ?? 0.0).toStringAsFixed(2).replaceFirst('.00', '');
}
