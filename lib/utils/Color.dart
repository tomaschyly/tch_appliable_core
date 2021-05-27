import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Convert the Color into hex string
  String toHex() {
    return '#${this.value.toRadixString(16)}';
  }
}
