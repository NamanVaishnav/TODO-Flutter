import 'package:get/get.dart';
import 'package:todo_flutter/db/db_helper.dart';
import 'package:todo_flutter/models/task.dart';

class TodoController extends GetxController {
  final RxList taskList = <Task>[].obs;
  int currentSelectedIndex = 0;

  getTaskList() {
    switch (currentSelectedIndex) {
      case 0:
        return getTodaysTask();
      case 1:
        return getTomorowTask();
      case 2:
        return getUpcomingTask();
    }
  }

  Future<void> getTask() async {
    final List<Map<String, dynamic>> tasks = await DBHelper().queryAllRows();
    // taskList.assignAll(tasks.map((data) => Task.fromMap(data)).toList());
  }

  Future<void> getTodaysTask() async {
    final List<Map<String, dynamic>> tasks = await DBHelper().queryTodaysRows();
    taskList.assignAll(tasks.map((data) => Task.fromMap(data)).toList());
  }

  Future<void> getTomorowTask() async {
    final List<Map<String, dynamic>> tasks =
        await DBHelper().queryTomorrowsRows();
    taskList.assignAll(tasks.map((data) => Task.fromMap(data)).toList());
  }

  Future<void> getUpcomingTask() async {
    final List<Map<String, dynamic>> tasks = await DBHelper().queryAllRows();
    final List<Map<String, dynamic>> tasksToday =
        await DBHelper().queryTodaysRows();
    final List<Map<String, dynamic>> tasksTomorrow =
        await DBHelper().queryTomorrowsRows();

    var allTaks = tasks.map((data) => Task.fromMap(data)).toList();
    var todayTaks = tasksToday.map((data) => Task.fromMap(data)).toList();
    var tomorrowTaks = tasksTomorrow.map((data) => Task.fromMap(data)).toList();

    todayTaks.forEach((element) {
      allTaks.removeWhere((element1) => element.id == element1.id);
    });
    tomorrowTaks.forEach((element) {
      allTaks.removeWhere((element1) => element.id == element1.id);
    });

    taskList.assignAll(allTaks);
  }

  addTask(Task task) async {
    await DBHelper().insertTask(task);
    taskList.add(task);
    getTaskList();
  }

  deleteTask(int? id) async {
    await DBHelper().delete(id!);
    getTaskList();
  }

  deleteAllTasks() async {
    await DBHelper().deleteAllTasks();
    getTaskList();
  }

  markAsCompleted(int? id) async {
    await DBHelper().update(id!);
    getTaskList();
  }
}
