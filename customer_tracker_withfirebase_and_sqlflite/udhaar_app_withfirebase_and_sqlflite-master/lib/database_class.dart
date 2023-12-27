import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';
class Databasehelper{
  static final _databaseName = 'udhaar_book_database.db';
  static final _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async{
    if(_database != null)
      return _database!;

    _database = await _initDatabase();
    return _database!;

  }
  Future<Database> _initDatabase() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }
  _onCreate(Database db, int version) async{
    await db.execute(
      '''
      CREATE TABLE customers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      phone TEXT
      )
    ''');
  }
  Future<int> insertCustomer(Customer customer) async{
    final db = await database;
    final id = await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }
  Future<List<Customer>> getAllCustomers() async{
    final db = await database;
    final maps = await db.query('customers');
    return maps.map((map) => Customer.fromMap(map)).toList();
}

}