import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class SQLiteRecord extends DataModel {
  static const String table = 'record';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colDescription = 'description';
  static const String colCreated = 'created';

  int? id;
  late String name;
  late String description;
  late int created;

  /// Create table
  static Future createTable(Database database) async {
    await database.execute('''
  CREATE TABLE $table (
    $colId INTEGER PRIMARY KEY AUTOINCREMENT,
    $colName TEXT NOT NULL,
    $colDescription TEXT NOT NULL,
    $colCreated INTEGER NOT NULL
  )
''');
  }

  /// SQLiteRecord initialization from JSON map
  SQLiteRecord.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json[colId];
    name = json[colName] ?? '';
    description = json[colDescription] ?? '';
    created = json[colCreated];
  }

  /// Convert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      colName: name,
      colDescription: description,
      colCreated: created,
    };

    if (id != null) {
      json[colId] = id;
    }

    return json;
  }
}
