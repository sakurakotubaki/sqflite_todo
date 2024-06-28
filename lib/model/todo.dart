class Todo {
  int? id;
  String title;
  bool done;

  Todo({this.id, required this.title, this.done = false});

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
