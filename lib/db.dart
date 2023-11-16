//import 'dart:io';
//import 'package:sqlite3/sqlite3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'your_database.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        // create the 'tasks' table if it doesn't exist
        await db.execute('''
          CREATE TABLE pests(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pestName TEXT,
            pesticide TEXT
          )
        ''');

        // insert some sample data
        await db.rawInsert(
            'INSERT INTO pests(pestName, pesticide) VALUES (?, ?)',
            ['Leaf Hopper Damage', 'Imidacloprid 200gl']);
        await db.rawInsert(
            'INSERT INTO pests(pestName, pesticide) VALUES (?, ?)',
            ['Stem Borers', 'Carbaryl,Chlorpyrifos']);
        await db.rawInsert(
            'INSERT INTO pests(pestName, pesticide) VALUES (?, ?)',
            ['Fruit Flies', ' Malathion, Chlorpyrifos']);
        await db.rawInsert(
            'INSERT INTO pests(pestName, pesticide) VALUES (?, ?)',
            ['Leaf-Hopper Damage', 'Imidacloprid 200gl']);
      },
    );
  }

  Future<List<Map<String, dynamic>>> getPesticide(String pest) async {
    String pattern = '$pest%';
    // Execute a SELECT query to get incomplete tasks from the 'tasks' table
    return await _database
        .query('pests', where: 'pestName LIKE ?', whereArgs: [pattern]);
  }
}
