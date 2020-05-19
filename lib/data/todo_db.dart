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
      await _openDb().then((db) {
        _database = db;
      });
    }
    return _database;
  }

  Future _openDb() async {
    final docsPath = await getApplicationDocumentsDirectory();
    final dbPath = join(docsPath.path, "todos.db");
    final db = await dbFactory.openDatabase(dbPath);
    return db;
  }
}
