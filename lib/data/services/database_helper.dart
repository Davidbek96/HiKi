import 'package:sqflite/sqflite.dart' as sql;
import 'package:hiki/data/models/cashflow_model.dart';

class DatabaseHelper {
  // Creates the necessary tables for storing cashflow data.
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
          CREATE TABLE cashflows (
            id TEXT PRIMARY KEY,
            title TEXT,
            amount REAL,
            date TEXT,
            category TEXT,
            isIncome INTEGER
          )
        ''');
  }

  // Opens or creates the SQLite database named "cashflow.db"
  // by using createTables() function
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'cashflow.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  //Fetch  Cashflows by ordering date and retun cashflow objects
  Future<List<CashFlow>> fetchCashflows() async {
    final db = await DatabaseHelper.db();
    final data = await db.query(
      'cashflows',
      orderBy: 'date DESC',
    );
    return data.map((e) => CashFlow.fromMap(e)).toList();
  }

  Future<List<CashFlow>> fetchCashflowsByDate(DateTime startDate) async {
    final db = await DatabaseHelper.db();

    // Convert startDate to a string in the format yyyy-MM-dd for comparison
    final startDateString = startDate.toIso8601String().split('T').first;

    // Query the database for cash flows from the start date until now, sorted by date
    final data = await db.query(
      'cashflows',
      where: 'date >= ?',
      whereArgs: [startDateString],
      orderBy: 'date DESC', // Sort by date in ascending order (earliest first)
    );
    // Map the results to CashFlow objects and return them
    return data.map((e) => CashFlow.fromMap(e)).toList();
  }

  // Adds a new cashflow record (income or expense) to the database.
  // If there's a conflict (e.g., duplicate ID), the existing record gets replaced.
  Future<int> insertCashflow(CashFlow cashflow) async {
    final db = await DatabaseHelper.db();
    return await db.insert('cashflows', cashflow.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  // Deletes a specific cashflow record based on its ID.
  Future<int> deleteCashflow(String id) async {
    final db = await DatabaseHelper.db();
    return await db.delete('cashflows', where: 'id = ?', whereArgs: [id]);
  }

  // Deletes all cashflow records from the database.
  Future<int> deleteAllCashflows() async {
    final db = await DatabaseHelper.db();
    return await db.delete('cashflows'); // Deletes all rows in the table
  }

  // Updates an existing cashflow record identified by its ID.
  // Allows changes to details like title, amount, date, category, or income status.
  // TODO - updateCashflow function is not used yet
  Future<int> updateCashflow(int id, CashFlow cashflow) async {
    final db = await DatabaseHelper.db();
    return await db.update(
      'cashflows',
      cashflow.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
