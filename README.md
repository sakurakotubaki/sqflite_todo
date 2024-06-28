# sqflite_todo

A new Flutter project.
```bash
flutter create sqfliete_todo
```

add package:
```bash
flutter pub add sqflite
```

### データ型について
No validity check is done on values yet so please avoid non supported types https://www.sqlite.org/datatype3.html

DateTime is not a supported SQLite type. Personally I store them as int (millisSinceEpoch) or string (iso8601)

bool is not a supported SQLite type. Use INTEGER and 0 and 1 values.

More information on supported types here.

INTEGER 
Dart type: int
Supported values: from -2^63 to 2^63 - 1
REAL 
Dart type: num
TEXT 
Dart type: String
BLOB 
Dart type: Uint8List

このテキストは、Flutter用のSQLiteプラグインであるsqfliteに関する説明です。sqfliteはiOS、Android、MacOSをサポートし、トランザクションやバッチ処理、自動バージョン管理、挿入/クエリ/更新/削除クエリのヘルパー機能、iOSとAndroidでのバックグラウンドスレッドでのDB操作実行などの機能を提供します。また、Linux/Windows/DartVMはsqflite_common_ffiを使用し、Webサポートはsqflite_common_ffi_webを使用して実験的にサポートされています。

使用例として、iOS/Android/Windows/Linux/Macで動作するシンプルなFlutterノートパッドアプリケーションが紹介されています。sqfliteをプロジェクトに追加する方法、データベースの開き方、スキーマ変更時の基本的なマイグレーションメカニズム、Raw SQLクエリの実行方法、SQLヘルパーを使用した例、トランザクションの使用方法、バッチサポート、テーブルとカラム名の扱い方、サポートされているSQLiteの型について説明されています。

SQLiteでは、bool型は直接サポートされていません。代わりに、INTEGER型を使用し、0と1の値でfalseとtrueを表現します。例えば、bool型のdoneフィールドは、データベースに保存する際にINTEGER型として0または1の値で保存され、読み込む際にはそれをbool値に変換して使用します。これは、上記のTodoクラスのtoMapメソッドとfromMapコンストラクタで示されています。

##  モデル作成の注意点
`bool`型をそのまま保存することが、できないので、`int`型に変換する必要があるみたい。

```dart
class Todo {
  int id;
  String title;
  bool done;

  Todo({required this.id, required this.title, this.done = false});

  // データベースに保存するために、boolをintに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done ? 1 : 0, // boolをintに変換
    };
  }

  // データベースから読み込む際に、intをboolに変換
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      done: map['done'] == 1, // intをboolに変換
    );
  }
}
```