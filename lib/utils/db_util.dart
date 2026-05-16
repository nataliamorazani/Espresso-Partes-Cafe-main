import 'package:espresso_partes_cafe/utils/db_tables_util.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static String dbName = 'ordem_de_servico.db';

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, dbName),
      onCreate: (db, version) {
        db.execute(DbTablesUtils.createTableQueryMyCompany);
        db.execute(DbTablesUtils.createTableQueryCustomers);
        db.execute(DbTablesUtils.createTableQueryProducts);
        db.execute(DbTablesUtils.createTableQueryProductSell);
        db.execute(DbTablesUtils.createTableQuerySales);
        db.execute(DbTablesUtils.createTableQuerySellPaymentDate);
        return;
      },
      version: 1,
    );
  }

  static Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await DbUtil.database();
    final int id = await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<void> update(
    String table,
    Map<String, dynamic> data, {
    where = "id = ?",
    required List whereArgs,
  }) async {
    final db = await DbUtil.database();
    await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: whereArgs,
    );
    // await db.close();
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();

    List<Map<String, dynamic>> results = await db.query(
      table,
      orderBy: 'name ASC',
    );
    // await db.close();

    if (results.isNotEmpty) {
      return results;
    } else {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getOne(
    String table, {
    where = 'id = ?',
    required List whereArgs,
  }) async {
    final db = await DbUtil.database();

    List<Map<String, dynamic>> results = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      limit: 1,
    );

    // await db.close();

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getDataWhere(
    String table, {
    required String where,
    required List whereArgs,
  }) async {
    final db = await DbUtil.database();

    List<Map<String, dynamic>> results = await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
    );

    // await db.close();

    if (results.isNotEmpty) {
      return results;
    } else {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDataByMonthAndYear(
      String table, DateTime date) async {
    final db = await DbUtil.database();

    final int month = date.month;
    final int year = date.year;

    List<Map<String, dynamic>> results = await db.query(
      table,
      where: "strftime('%m', sell_date) = ? AND strftime('%Y', sell_date) = ?",
      orderBy: 'id DESC',
      whereArgs: [month.toString().padLeft(2, '0'), year.toString()],
    );

    return results;
  }

  static Future<bool> delete(
    String table, {
    required String where,
    required List whereArgs,
  }) async {
    final db = await DbUtil.database();

    int results = await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );

    // await db.close();

    if (results == 1) {
      return true;
    } else {
      return false;
    }
  }
}
