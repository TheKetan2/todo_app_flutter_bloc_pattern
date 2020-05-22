import 'dart:async';
import "package:path_provider/path_provider.dart";
import "package:path/path.dart";
import "package:sembast/sembast.dart";
import "package:sembast/sembast_io.dart";

import "todo.dart";

class TodoDb {
  static final TodoDb _singleton = TodoDb._internal();
  TodoDb._internal();
/*
A normal constructor returns a new instance of the current class. A factory
constructor can only return a single instance of the current class: that's
why factory constructors are often used when you need to implement the
singleton pattern

 */
  factory TodoDb() {
    return _singleton;
  }

  DatabaseFactory dbFactory = databaseFactoryIo;

  final store = intMapStoreFactory.store("todos");

  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      await _openDb().then(
        (db) {
          _database = db;
        },
      );
    }
    return _database;
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, "todos.db");
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future insertTodo(Todo todo) async {
    await store.add(_database, todo.toMap());
  }

  /*Similarly, to update an existing item in the database, you can call the update()
method of the store. The difference here is that you also need another object:
a Finder. A Finder is a helper that you can use to search inside a store. With the
update() method, you need to retrieve a Todo before updating it, so you need
the Finder before you update the document. */

  Future updateTodo(Todo todo) async {
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database, todo.toMap(), finder: finder);
  }
}
