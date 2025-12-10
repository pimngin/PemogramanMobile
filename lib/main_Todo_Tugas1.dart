import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: TodoListScreen()));
}

// 1. Model Todo (Sesuai materi hal 16)
class Todo {
  String id;
  String title;
  bool isCompleted;
  DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  String filter = 'Semua'; // Pilihan: Semua, Selesai, Belum Selesai

  @override
  void initState() {
    super.initState();
    loadTodos(); // Load data saat aplikasi dibuka [cite: 195]
  }

  // 2. SharedPreferences Logic
  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List<dynamic> todosJson = jsonDecode(todosString);
      setState(() {
        todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      });
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> todosJson =
    todos.map((todo) => todo.toJson()).toList();
    await prefs.setString('todos', jsonEncode(todosJson));
  }

  // CRUD Operations
  void _addTodo(String title) {
    setState(() {
      todos.add(Todo(
        id: DateTime.now().toString(),
        title: title,
        createdAt: DateTime.now(),
      ));
    });
    saveTodos();
  }

  void _toggleTodo(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
    saveTodos();
  }

  void _deleteTodo(String id) {
    setState(() {
      todos.removeWhere((item) => item.id == id);
    });
    saveTodos();
  }

  void _editTodo(int index, String newTitle) {
    setState(() {
      todos[index].title = newTitle;
    });
    saveTodos();
  }

  // Filter Logic
  List<Todo> get filteredTodos {
    if (filter == 'Selesai') {
      return todos.where((todo) => todo.isCompleted).toList();
    } else if (filter == 'Belum Selesai') {
      return todos.where((todo) => !todo.isCompleted).toList();
    }
    return todos;
  }

  void _showTodoDialog({int? index}) {
    final isEdit = index != null;
    final titleController = TextEditingController(
      text: isEdit ? filteredTodos[index].title : '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Todo' : 'Tambah Todo'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Judul Kegiatan'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                if (isEdit) {
                  // Cari index asli di list utama berdasarkan ID karena list yang ditampilkan terfilter
                  int originalIndex = todos.indexOf(filteredTodos[index]);
                  _editTodo(originalIndex, titleController.text);
                } else {
                  _addTodo(titleController.text);
                }
                Navigator.pop(context);
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          DropdownButton<String>(
            value: filter,
            icon: Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.blue,
            underline: SizedBox(),
            items: ['Semua', 'Selesai', 'Belum Selesai']
                .map((String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
                .toList(),
            onChanged: (newValue) {
              setState(() {
                filter = newValue!;
              });
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTodos.length,
        itemBuilder: (context, index) {
          final todo = filteredTodos[index];
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (_) {
                  // Cari index asli
                  int originalIndex = todos.indexOf(todo);
                  _toggleTodo(originalIndex);
                },
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showTodoDialog(index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTodo(todo.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTodoDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}