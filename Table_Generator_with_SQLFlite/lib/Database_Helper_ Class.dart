import 'dart:math';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Generated_table_class.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'generated_tables';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'generated_tables.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tableNumber INTEGER,
          upperLimit INTEGER,
          lowerLimit INTEGER,
          generatedTableEntries TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE quiz_records (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tableNumber INTEGER,
          numberOfQuestions INTEGER,
          correctAnswers INTEGER
        )
      ''');
      },
    );
  }

  Future<int> insertTable(GeneratedTable table) async {
    final db = await database;
    return db.insert(tableName, table.toMap());
  }

  Future<List<GeneratedTable>> getAllTables() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      var table = GeneratedTable(
        id: maps[i]['id'],
        tableNumber: maps[i]['tableNumber'],
        upperLimit: maps[i]['upperLimit'],
        lowerLimit: maps[i]['lowerLimit'],
        generatedTableEntries: [],
      );
      table.deserializeTableEntries(maps[i]['generatedTableEntries']);
      return table;
    });
  }

  Future<int> updateTable(GeneratedTable table) async {
    final db = await database;
    return await db.update(
      tableName,
      table.toMap(),
      where: 'id = ?',
      whereArgs: [table.id],
    );
  }

  Future<int> deleteTable(int id) async {
    final db = await database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isTableExists(int tableNumber) async {
    final db = await database;
    var result = await db.query(
      'generated_tables',
      where: 'tableNumber = ?',
      whereArgs: [tableNumber],
    );

    return result.isNotEmpty;
  }

  List<bool> generateRandomTrueFalseQuestions(GeneratedTable table) {
    Random random = Random();
    List<bool> questions = [];

    for (int i = 0; i < table.generatedTableEntries.length; i++) {
      questions.add(random.nextBool());
    }

    return questions;
  }

  Future<List<int>> getTableEntries(int tableNumber) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'generated_tables',
      columns: ['entries'],
      where: 'table_number = ?',
      whereArgs: [tableNumber],
    );

    if (result.isNotEmpty) {
      String entriesString = result.first['entries'];
      List<int> entries =
          entriesString.split(',').map((e) => int.parse(e)).toList();
      return entries;
    } else {
      return [];
    }
  }

  Future<int> insertQuizRecord(
      int tableNumber, int numberOfQuestions, int correctAnswers) async {
    Database db = await database;
    return await db.insert('quiz_records', {
      'tableNumber': tableNumber,
      'numberOfQuestions': numberOfQuestions,
      'correctAnswers': correctAnswers,
    });
  }

  Future<List<Map<String, dynamic>>> getQuizRecords() async {
    Database db = await database;
    return await db.query('quiz_records');
  }

  static Future<void> deleteQuizRecord(int quizId) async {
    print('Deleting quiz record with ID: $quizId');
    final Database db = await DatabaseHelper().database;
    await db.delete('quiz_records', where: 'id = ?', whereArgs: [quizId]);
    print('Quiz record deleted successfully');
  }
}
