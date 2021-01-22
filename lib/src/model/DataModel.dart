abstract class DataModel {
  /// DataModel initialization from JSON map
  DataModel.fromJson(Map<String, dynamic> json);

  /// Covert the object into JSON map
  Map<String, dynamic> toJson();
}
