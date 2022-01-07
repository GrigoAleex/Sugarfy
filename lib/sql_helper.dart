import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    /**
     * id: the id of a item
     * grammage: the sugar grammage that was eaten
     * created_at: the time that the item was created. It will be automatically handled by SQLite
     */
    await database.execute("""
      CREATE TABLE logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        grammage INTEGER,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'sugarfy.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> store(int grammage) async {
    final db = await SQLHelper.db();
    
    return await db.insert(
      'logs', 
      {'grammage': grammage},
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
  }

  static Future<List<Map<String, dynamic>>> index() async {
    final db = await SQLHelper.db();
    return db.query('logs', orderBy: "id");
  }

  // Delete
  static Future<void> destroy(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("logs", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an log: $err");
    }
  }
}