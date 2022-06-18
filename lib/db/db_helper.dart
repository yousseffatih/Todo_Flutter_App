
import "package:sqflite/sqflite.dart";
import "package:flutter/material.dart";
import 'package:to_do_app/models/task.dart';


class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "taskss";

  static  Future<void > initDb() async {


    if(_db != null)
    {
      debugPrint('Not null DB');
      return;
    }
    else
    {
      try {
        String _path = await getDatabasesPath() + 'Tasks.db';
                  debugPrint('in database path');
        _db = await openDatabase(_path, version : _version,
    onCreate: (Database db, int version) async {
            debugPrint('creating a new one');
  // When creating the db, create the table
  await db.execute(
      '''CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title STRING, note TEXT,isCompleted INTEGER,date STRING,
        startTime STRING,endTime STRING,
        color INTEGER ,
        remind INTEGER , repeat INTEGER
        )'''
      );
});  
     print("Data base Created");
      } catch (e) {
        print(e);
      }
    }
  }
  

   static Future<int> insert(Task? task) async{
    print(" insert function called");
    try
    {
      return await _db!.insert(_tableName, task!.toJson());
    }
    catch (e)
    {
      print("We are here");
      print(e);
      return 90000;
    }
  }

  static  delete(Task task) async{
    print(" Delete function called");
    return await _db!.delete(_tableName , where: " id =?" , whereArgs: [task.id]);
  }

  static  deleteAll() async{
    print(" Delete All function called");
    return await _db!.delete(_tableName);
  }

  static  query() async{
    print(" query function called");
    return await _db!.query(_tableName);
  }

  static  update(int id) async{
    print(" update function called");
    return await _db!.rawUpdate(''' 
    UPDATE taskss 
    SET isCompleted = ?
    WHERE id =?
    ''', [1,id]);
  }

}
