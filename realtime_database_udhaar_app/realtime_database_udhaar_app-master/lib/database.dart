import 'package:csv/csv.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models.dart';
import 'dart:io';

class DatabaseHelper {
  static final _databaseName = 'udhar_book.db';
  static final _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
 CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL, 
    phone TEXT,
    photo TEXT  -- Add this line to include the "photo" column
  )
  ''');
    await db.execute('''
    CREATE TABLE sales (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
      amount REAL NOT NULL,
      sale_date TEXT NOT NULL,
      sale_time TEXT NOT NULL
    )
  ''');
    await db.execute('''
    CREATE TABLE expenses (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      customer_id INTEGER NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
      amount REAL NOT NULL,  -- Add this line
      expense_date TEXT NOT NULL,
      expense_time TEXT NOT NULL
    )
  ''');
  }


  Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    final id = await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }


  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final maps = await db.query('customers');
    return maps.map((map) => Customer.fromMap(map)).toList();
  }

  Future<Customer?> getCustomer(int id) async {
    final db = await database;
    final maps = await db.query('customers', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? Customer.fromMap(maps.first) : null;
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getBalanceForCustomer(int customerId) async {
    final sales = await getSalesForCustomer(customerId);
    final expenses = await getExpensesForCustomer(customerId);

    final totalSales = sales.fold(0.0, (sum, sale) => sum + sale.amount);
    final totalExpenses = expenses.fold(0.0, (sum, expense) => sum + expense.amount);

    return totalSales - totalExpenses;
  }

  Future<int> insertSale(Sale sale) async {
    final db = await database;
    final id = await db.insert('sales', {
      'customer_id': sale.customerId,
      'amount': sale.amount,
      'sale_date': sale.saleDate.toIso8601String(),
      'sale_time': '${sale.saleTime.hour}:${sale.saleTime.minute}',
    });
    return id;
  }


  Future<List<Sale>> getSalesForCustomer(int customerId) async {
    final db = await database;
    final maps = await db.query('sales', where: 'customer_id = ?', whereArgs: [customerId]);
    return maps.map((map) => Sale.fromMap(map)).toList();
  }
  Future<int> updateSale(Sale sale) async {
    final db = await database;
    return await db.update(
      'sales',
      sale.toMap(),
      where: 'id = ?',
      whereArgs: [sale.id],
    );
  }
  Future<int> deleteSale(int id) async {
    final db = await database;
    return await db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    final id = await db.insert('expenses', {
      'customer_id': expense.customerId,
      'amount': expense.amount,
      'expense_date': expense.expenseDate.toIso8601String(),
      'expense_time': '${expense.expenseTime.hour}:${expense.expenseTime.minute}',
      // Store date as ISO 8601 string
    });
    return id;
  }


  Future<List<Expense>> getExpensesForCustomer(int customerId) async {
    final db = await database;
    final maps = await db.query('expenses', where: 'customer_id = ?', whereArgs: [customerId]);
    return maps.map((map) => Expense.fromMap(map)).toList();
  }
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> exportCustomerData(String filePath) async {
    final customers = await getAllCustomers();
    final balances = await Future.wait(customers.map((customer) => getBalanceForCustomer(customer.id!)));

    final csvData = StringBuffer();
    csvData.write('Name,Balance\n');
    for (int i = 0; i < customers.length; i++) {
      csvData.write('${customers[i].name},${balances[i]}\n');
    }

    final file = File(filePath);
    await file.writeAsString(csvData.toString());
  }

}
