import 'package:flutter/material.dart';
import 'package:sqflite_todo/api/database_helper.dart';
import 'package:sqflite_todo/model/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDone = false;
  final titleController = TextEditingController();
  // DatabaseHelperをインスタンス化
  final dbHelper = DatabaseHelper();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Todo> todos = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Todo List'),
      ),
      // Todoのリストを表示
      body: FutureBuilder<List<Todo>>(
        future: dbHelper.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index].title),
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Todoを削除
                      dbHelper.deleteTodo(todos[index].id!);
                      setState(() {
                        todos.removeAt(index);
                      });
                    },
                  ),
                  trailing: Checkbox(
                    value: todos[index].done,
                    onChanged: (value) {
                      // Todoのdoneを更新
                      final todo = Todo(
                        id: todos[index].id,
                        title: todos[index].title,
                        done: value!,
                      );
                      dbHelper.updateTodoDone(todo);
                      setState(() {
                        todos[index].done = value;
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheetを使用してモーダルボトムシートを表示
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // コンテンツのサイズに合わせて高さを調整
                    children: <Widget>[
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final title = titleController.text;
                          if (title.isNotEmpty) {
                            final todo = Todo(
                              title: title,
                            );
                            await dbHelper.addTodo(todo);
                            setState(() {
                              // Todoを追加
                              titleController.clear();
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
