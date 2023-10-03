import 'dart:ffi';
import 'package:m03/ShoppingList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:m03/ShoppingList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  Database? _database;
  final String _tabelName = "shopping_list";
  final String _dbName = "shopinglist_database.db";
  final int _db_version = 1;

  DBHelper() {
    _openDB();
  }
  Future<void> _openDB() async{
    _database ??= await openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $_tabelName (id INTEGER PRIMARY KEY, name TEXT, sum INTEGER)",
        );
      },
      version: _db_version,
    );
  }
  Future<void> insertShoppingList(ShoppingList tmp) async{
    await _database?.insert(
      "shopping_list",
      tmp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<ShoppingList>> getmyShoppingList() async{
    if (_database !=null) {
      final List<Map<String, dynamic>> maps = 
          await _database!.query("shopping_List");
      print("Isi DB" +maps.toString());
      return List.generate(maps.length, (i) {
        return ShoppingList(maps[i]["id"], maps[i]["name"], maps[i]["sum"]);
      });
    }
    return[];
  }
  Future<void> deleteShoppingList(int id) async{
    await _database?.delete(
      "shhopping_list",
      where: "id = ?",
      whereArgs: [id],
    );
  }
  Future<void> closeDB() async{
    await _database?.close();
  }
  Future<void> deleteAllShoppingList() async {
  if (_database != null) {
    await _database!.delete(_tabelName);
  }
  }

}