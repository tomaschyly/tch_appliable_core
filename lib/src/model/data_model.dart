import 'package:flutter/material.dart';

abstract class DataModel {
  @protected
  Map<String, dynamic> json;

  /// DataModel initialization from JSON map
  DataModel.fromJson(this.json);

  /// Convert the object into JSON map
  Map<String, dynamic> toJson();
}
