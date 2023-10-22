import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// If possible convert text value to double number
double? stringToDouble(String? text) {
  if (text == null) return null;

  try {
    final num parsed = NumberFormat.decimalPattern(WidgetsBinding.instance.window.locale.languageCode).parse(text);

    return parsed.toDouble();
  } catch (e) {}

  return double.tryParse(text);
}

/// Convert double to string respecting decimal symbol by Locale
String doubleToString(double value) {
  try {
    return NumberFormat.decimalPattern(WidgetsBinding.instance.window.locale.languageCode).format(value);
  } catch (e) {}

  return value.toString();
}

/// Convert double to currency text formatted with decimals
String doubleAsCurrency(double? value) {
  try {
    return NumberFormat.decimalPattern(WidgetsBinding.instance.window.locale.languageCode).format(value ?? 0.0);
  } catch (e) {}

  return (value ?? 0.0).toStringAsFixed(2).replaceFirst('.00', '');
}
