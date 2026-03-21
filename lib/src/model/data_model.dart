abstract class DataModel {
  /// DataModel initialization from JSON map
  DataModel.fromJson(Map<String, dynamic> json);

  /// Convert the object into JSON map
  Map<String, dynamic> toJson();
}
