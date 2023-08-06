import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'todo.db');

    return await openDatabase(
      databasePath,
      version: 1,
      singleInstance: true,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updatedAt TIMESTAMP
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final db = await database;
    return await db.query('todos');
  }

  Future<int> insert({
    required String title,
  }) async {
    final db = await database;
    final data = {
      'title': title,
    };
    return await db.insert('todos', data);
  }

  Future<int> update({
    required int id,
    required String title,
  }) async {
    final db = await database;
    final data = {
      'title': title,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    return await db.update('todos', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete({
    required int id,
  }) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('todos');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
