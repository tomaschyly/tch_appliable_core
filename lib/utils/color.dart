import 'package:flutter/material.dart';

/// Convenience class for easy autoimport
class ColorExtensionDummy {}

extension ColorExtension on Color {
  /// Convert the Color into hex string
  String toHex() {
    return '#${toARGB32().toRadixString(16)}';
  }
}
