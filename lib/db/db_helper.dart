import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_flutter/models/task.dart';

class DBHelper {
  static const _databaseName = 'todo.db';
  static const _tasksTable = 'tasks_table';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $_tasksTable('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, color INTEGER, isCompleted INTEGER'
        ')');
  }

  Future<int> insertTask(Task task) async {
    Database? db = await DBHelper._database;
    return await db!.insert(_tasksTable, {
      'title': task.title,
      'note': task.note,
      'date': task.date,
      'startTime': task.startTime,
      'endTime': task.endTime,
      'color': task.color,
      'isCompleted': task.isCompleted,
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await DBHelper._database;
    return await db!.query(_tasksTable);
  }

  Future<List<Map<String, dynamic>>> queryTodaysRows() async {
    Database? db = await DBHelper._database;

    return await db!.query(_tasksTable,
        where: 'date = ?',
        whereArgs: [DateFormat.yMd().format(DateTime.now())]);
  }

  Future<List<Map<String, dynamic>>> queryTomorrowsRows() async {
    Database? db = await DBHelper._database;
    return await db!.query(_tasksTable, where: 'date = ?', whereArgs: [
      DateFormat.yMd().format(DateTime.now().add(const Duration(days: 1)))
    ]);
  }

  Future<int> delete(int id) async {
    Database? db = await DBHelper._database;
    return await db!.delete(_tasksTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllTasks() async {
    Database? db = await DBHelper._database;
    return await db!.delete(_tasksTable);
  }

  Future<int> updateAllFields(Task task) async {
    return await _database!.rawUpdate('''
    UPDATE $_tasksTable
    SET title = ?, note = ?, date = ?, startTime = ?, endTime = ?, isCompleted = ?, color = ?
    WHERE id = ?
    ''', [
      task.title,
      task.note,
      task.date,
      task.startTime,
      task.endTime,
      0,
      0,
      task.id
    ]);
  }

  Future<int> update(int id) async {
    return await _database!.rawUpdate('''
    UPDATE $_tasksTable
    SET isCompleted = ?, color = ?
    WHERE id = ?
    ''', [1, 1, id]);
  }
}
