import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_todo/model/todo.dart';

// データベースの操作を行うクラス
class DatabaseHelper {
  // データベースのバージョン
  static const int _databaseVersion = 1;
  // データベースの名前
  static const String _databaseName = 'todo.db';

  // データベースのインスタンスを取得
  Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName), // データベースのパスを指定
      version: _databaseVersion, // データベースのバージョンを指定
      onCreate: (db, version) async {
        // データベースにテーブルを作成
        await db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, done INTEGER)',
        );
      },
    );
  }

  // Todoをデータベースに追加
  Future<int> addTodo(Todo todo) async {
    final db = await _getDB(); // データベースのインスタンスを取得
    return db.insert(
      'todos', // テーブル名
      todo.toJson(), // TodoをMap型に変換して挿入
      conflictAlgorithm: ConflictAlgorithm.replace, // データが重複した場合は置き換える
    );
  }

  // Todoのdoneを更新
  Future<int> updateTodoDone(Todo todo) async {
    final db = await _getDB();
    return db.update(
      'todos',
      {'done': todo.done ? 1 : 0}, // doneのみを更新するためのMap
      where: 'id = ?',
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Todoを削除
  Future<int> deleteTodo(int id) async {
    final db = await _getDB();
    return db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // すべてのTodoを取得
  Future<List<Todo>> getTodos() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'],
        done: maps[i]['done'] == 1,
      );
    });
  }
}