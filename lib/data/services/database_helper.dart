import 'dart:developer';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:hiki/data/models/cashflow_model.dart';

class DatabaseHelper {
  // Creates the necessary tables for storing cashflow data.
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS cashflows (
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        date TEXT,
        category TEXT,
        isIncome INTEGER
      )
    ''');
  }

  /// Return the canonical persistent database path and migrate legacy files if found.
  static Future<sql.Database> db() async {
    // new canonical path (sqflite recommended location)
    final databasesPath = await sql.getDatabasesPath();
    final newPath = p.join(databasesPath, 'cashflow.db');

    // prepare list of candidate legacy paths to check (common app dirs)
    final List<String> legacyCandidates = [];

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      legacyCandidates.add(p.join(appDocDir.path, 'cashflow.db'));
    } catch (e) {
      log('Could not get applicationDocumentsDirectory: $e');
    }

    try {
      final appSupportDir = await getApplicationSupportDirectory();
      legacyCandidates.add(p.join(appSupportDir.path, 'cashflow.db'));
    } catch (e) {
      log('Could not get applicationSupportDirectory: $e');
    }

    // Some older or incorrect usages may have placed the DB in the "databases" folder already
    try {
      // ensure the target directory exists
      final targetDir = io.Directory(p.dirname(newPath));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }
    } catch (e) {
      log('Error ensuring target directory exists: $e');
    }

    // If new DB already exists, no migration needed
    final newFile = io.File(newPath);
    if (!await newFile.exists()) {
      // search for a legacy DB to migrate
      for (final legacyPath in legacyCandidates) {
        try {
          if (legacyPath == newPath) continue;
          final f = io.File(legacyPath);
          if (await f.exists()) {
            // copy the legacy DB to new location
            await f.copy(newPath);
            log('Migrated database from $legacyPath -> $newPath');
            break;
          }
        } catch (e) {
          log('Error while checking/copying legacy DB at $legacyPath: $e');
        }
      }
    } else {
      log('Database already at canonical path: $newPath');
    }

    // finally open the database at the canonical path
    return sql.openDatabase(
      newPath,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Implement schema migrations here when you bump version
        // e.g. if (oldVersion < 2) { await db.execute(...); }
        log('DB upgrade: $oldVersion -> $newVersion');
      },
      onOpen: (db) async {
        // Ensure tables exist (safety)
        await createTables(db);
      },
    );
  }

  // ---------- rest of your DatabaseHelper methods (unchanged) ----------
  Future<List<CashFlow>> fetchCashflows() async {
    final db = await DatabaseHelper.db();
    final data = await db.query('cashflows', orderBy: 'date DESC');
    return data.map((e) => CashFlow.fromMap(e)).toList();
  }

  Future<List<CashFlow>> fetchCashflowsByDate(DateTime startDate) async {
    final db = await DatabaseHelper.db();
    final startDateString = startDate.toIso8601String().split('T').first;
    final data = await db.query(
      'cashflows',
      where: 'date >= ?',
      whereArgs: [startDateString],
      orderBy: 'date DESC',
    );
    return data.map((e) => CashFlow.fromMap(e)).toList();
  }

  Future<int> insertCashflow(CashFlow cashflow) async {
    log('Cashflow id while inserting database : ${cashflow.id}');
    final db = await DatabaseHelper.db();
    return await db.insert(
      'cashflows',
      cashflow.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBatchCashflows(List<CashFlow> cashflows) async {
    if (cashflows.isEmpty) return;
    final db = await DatabaseHelper.db();
    final batch = db.batch();
    for (var cashflow in cashflows) {
      batch.insert(
        'cashflows',
        cashflow.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    log('Inserted ${cashflows.length} cashflows in batch');
  }

  Future<int> deleteCashflow(String id) async {
    final db = await DatabaseHelper.db();
    return await db.delete('cashflows', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteBatchCashflows(List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await DatabaseHelper.db();
    final batch = db.batch();
    for (var id in ids) {
      batch.delete('cashflows', where: 'id = ?', whereArgs: [id]);
    }
    await batch.commit(noResult: true);
    log('Deleted ${ids.length} cashflows in batch');
  }

  Future<int> deleteAllCashflows() async {
    final db = await DatabaseHelper.db();
    return await db.delete('cashflows');
  }

  Future<int> updateCashflow(String id, CashFlow cashflow) async {
    log('Cashflow.id while updating in database  : ${cashflow.id}');
    log('String id while updating in database  : $id');
    final db = await DatabaseHelper.db();
    final updateResult = await db.update(
      'cashflows',
      cashflow.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    log('Update in database result : $updateResult');
    return updateResult;
  }
}
