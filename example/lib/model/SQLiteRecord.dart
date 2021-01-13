import 'package:tch_appliable_core/tch_appliable_core.dart';

class SQLiteRecord extends DataModel {
  static const String TABLE = 'record';
  static const String COL_ID = 'id';
  static const String COL_NAME = 'name';
  static const String COL_DESCRIPTION = 'description';
  static const String COL_CREATED = 'created';

  int? id;
  late String name;
  late String description;
  late int created;

  /// Create table
  static Future createTable(Database database) async {
    await database.execute('''
  CREATE TABLE $TABLE (
    $COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    $COL_NAME TEXT NOT NULL,
    $COL_DESCRIPTION TEXT NOT NULL,
    $COL_CREATED INTEGER NOT NULL
  )
''');
  }

  /// SQLiteRecord initialization from JSON map
  SQLiteRecord.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json[COL_ID];
    name = json[COL_NAME] ?? '';
    description = json[COL_DESCRIPTION] ?? '';
    created = json[COL_CREATED];
  }

  /// Covert the object into JSON map
  @override
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      COL_NAME: name,
      COL_DESCRIPTION: description,
      COL_CREATED: created,
    };

    if (id != null) {
      json[COL_ID] = id;
    }

    return json;
  }
}
