import 'package:etiqa_to_do_list/model/to_do_list.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHandler {
  //Awann 31 Dec 2022
  //initialiase DB
  Future<Database> initialiseDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'mydatabase.db'),
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE etiqa_to_do_list(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, status TEXT, startDate TEXT, endDate TEXT)');
      },
      version: 1,
    );
  }

  //insert initial record
  Future<int> initToDoList(List<ToDoList> todoList) async {
    int result = 0;
    final Database db = await initialiseDB();
    //do a loop to insert
    for (var todo in todoList) {
      try {
        result = await db.insert('etiqa_to_do_list', todo.toMap());
      } catch (e) {
        debugPrint('error in insert 1st record : $e');
      }
    }
    return result;
  }

  //insert record
  Future<int> insertToDoList(ToDoList toDoList) async {
    int result = 0;
    final Database db = await initialiseDB();
    //do a loop to insert
    result = await db.insert('etiqa_to_do_list', toDoList.toMap());
    debugPrint('result add : $result');
    return result;
  }

  //get record
  Future<List<ToDoList>> retrieveToDoList() async {
    final Database db = await initialiseDB();
    List<Map<String, Object?>> queryResult = await db.query('etiqa_to_do_list');
    return queryResult.map((e) => ToDoList.fromMap(e)).toList();
  }

  //update record
  Future<void> updateToDoList(ToDoList toDoList) async {
    final Database db = await initialiseDB();
    await db.update(
      'etiqa_to_do_list',
      toDoList.toMap(),
      where: 'id = ?',
      whereArgs: [toDoList.id],
    );
  }

  //delete record
  Future<void> removeToDoList(int id) async {
    final Database db = await initialiseDB();
    await db.delete(
      'etiqa_to_do_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //delete all record
  Future<void> deleteAllRecord() async {
    final Database db = await initialiseDB();
    await db.delete(
      'etiqa_to_do_list',
    );
  }
}
