
import 'package:get/get.dart';
import 'package:to_do_app/db/db_helper.dart';
import 'package:to_do_app/models/task.dart';

class TaskController extends GetxController{

  final tasklist =<Task>[].obs;

  Future<int> addTask({Task? task})
  {
    return  DBHelper.insert(task!);
  }
  Future<void> getTasks()async{
    final List<Map<String , dynamic>> tasks = await  DBHelper.query();
    tasklist.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  deleteTasks(Task task)async{
    await  DBHelper.delete(task);
    getTasks();
  }

  deleteAllTasks()async{
    await  DBHelper.deleteAll();
    getTasks();
  }

  markTaskCompleted(int id)async{
    await  DBHelper.update(id);
    getTasks();
  }

  


}
