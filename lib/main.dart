import 'package:flutter/material.dart';
import 'database/database_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List todos = [];
  DatabaseService db = DatabaseService();
  bool isLoading = false;
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    setState(() {
      isLoading = true;
    });
    final data = await db.fetchTodos();
    setState(() {
      todos = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(
        title: const Text(
          'All Tasks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 60, 36, 68),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : todos.isEmpty
              ? const Center(
                  child: Text(
                    'No Todos',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return GestureDetector(
                      onTap: () async {
                        titleController.text = todo['title'];
                        await addTodoForm(
                          context: context,
                          db: db,
                          titleController: titleController,
                          onClick: () async {
                            await db.update(
                              id: todo['id'],
                              title: titleController.text,
                            );
                            titleController.clear();
                            refresh();
                          },
                          isUpdate: true,
                        );
                        refresh();
                      },
                      child: Card(
                        margin: EdgeInsets.only(
                          top: index == 0 ? 12 : 4,
                          bottom: 4,
                          left: 6,
                          right: 6,
                        ),
                        color: const Color.fromARGB(255, 53, 47, 66),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          title: Text(
                            todo['title'],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            todo['createdAt'],
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await db.delete(
                                id: todo['id'],
                              );
                              refresh();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.clear();
          addTodoForm(
            context: context,
            db: db,
            titleController: titleController,
            onClick: () async {
              await db.insert(title: titleController.text);
              titleController.clear();
              refresh();
            },
            isUpdate: false,
          );
          refresh();
        },
        backgroundColor: const Color.fromARGB(255, 60, 36, 68),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Bottom modelsheet for adding new todo
addTodoForm({
  required BuildContext context,
  required DatabaseService db,
  required TextEditingController titleController,
  required Function onClick,
  required bool isUpdate,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isUpdate ? "Update Task" : "Add New Task",
                style: const TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter New Task',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black),
                controller: titleController,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  onClick();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(isUpdate ? "Update" : "Add"),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
