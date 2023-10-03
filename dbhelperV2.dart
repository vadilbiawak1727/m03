import 'package:m03/ShoppingList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Database? _database;
  final String _tableName = "shopping_list"; // Ubah dari "shopping_List" ke "_tableName"
  final String _dbName = "shopinglist_database.db";
  final int _db_version = 1; // Tambahkan versi database

  DBHelper() {
    _openDB();
  }

  Future<void> _openDB() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)", // Gunakan _tableName
        );
      },
      version: _db_version, // Tambahkan versi database
    );
  }

  Future<void> insertShoppingList(ShoppingList tmp) async {
    await _database?.insert(
      _tableName, // Gunakan _tableName
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ShoppingList>> getmyShoppingList() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps = await _database!.query(_tableName); // Gunakan _tableName
      print("Isi DB" + maps.toString());
      return List.generate(maps.length, (i) {
        return ShoppingList(maps[i]["id"], maps[i]["name"], maps[i]["sum"]);
      });
    }
    return [];
  }
}
