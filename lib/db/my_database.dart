import 'package:sqflite/sqflite.dart';
import 'package:sqlite/db/db_fields.dart';
import 'package:sqlite/model/task_model.dart';
import 'package:sqlite/utils.dart';

class MyDatabase {
  static final MyDatabase instance = MyDatabase._internal();

  static Database? _database;

  MyDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/task.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    await db.execute('''
        CREATE TABLE ${DbFields.tableName} (
          ${DbFields.id} ${DbFields.idType},
          ${DbFields.date} ${DbFields.textType},
          ${DbFields.month} ${DbFields.textType},
          ${DbFields.title} ${DbFields.textType},
          ${DbFields.quantity} ${DbFields.textType},
          ${DbFields.price} ${DbFields.realType}
        )
      ''');
  }

  Future<TaskModel> create(TaskModel task) async {
    final db = await instance.database;
    final id = await db.insert(DbFields.tableName, task.toJson());
    return task.copy(id: id);
  }

  Future<List<TaskModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${DbFields.date} ASC';
    final result = await db.query(DbFields.tableName, orderBy: orderBy);
    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> readById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      DbFields.tableName,
      columns: DbFields.values,
      where: '${DbFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<int> update(TaskModel task) async {
    final db = await instance.database;
    return db.update(
      DbFields.tableName,
      task.toJson(),
      where: '${DbFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      DbFields.tableName,
      where: '${DbFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<TaskModel>> filterTasks(String month, String title) async {
    final db = await instance.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (month.isNotEmpty && title.isNotEmpty) {
      whereClause = '${DbFields.month} = ? AND ${DbFields.title} = ?';
      whereArgs = [month, title.toUpperCase().trim()];
    } else if (month.isNotEmpty && title.isEmpty) {
      whereClause = '${DbFields.month} = ?';
      whereArgs = [month];
    } else if (month.isEmpty && title.isNotEmpty) {
      whereClause = '${DbFields.title} = ?';
      whereArgs = [title.toUpperCase().trim()];
    } else {
      whereClause = '';
      whereArgs = [];
    }

    if (whereClause.isNotEmpty) {
      final maps = await db.query(
        DbFields.tableName,
        columns: DbFields.values,
        where: whereClause,
        whereArgs: whereArgs,
      );
      return maps.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}