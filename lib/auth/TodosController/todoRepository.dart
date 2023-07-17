import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/notificationService.dart';

import '../../models/todos.dart';
import '../../offline_database/database.dart';

class TodoRepository extends GetxController {
  static TodoRepository get instance => Get.find();
  DateTime dateNow = DateTime.now();
  NotifyTask notifyTask = NotifyTask();
  final box = Hive.box('todogoBox');
  final philippineTimeZone = tz.getLocation('Asia/Manila');

  addTodos(categoryName, doThis, hr, min, amPm, day, mon, year) {
    final userData = box.get('todoGoUser');
    final newTask = Task(
        todos: doThis,
        isDone: false,
        hour: hr.toString(),
        minute: min.toString(),
        isAM: amPm,
        day: day.toString(),
        month: mon.toString(),
        year: year.toString());

    final category = userData.categories
        .firstWhere((category) => category.name == categoryName);
    if (category != null) {
      category.tasks.add(newTask);
      box.put('todoGoUser', userData);
    }
    var taskDateTime = tz.TZDateTime(
      philippineTimeZone,
      int.parse(year),
      int.parse(mon),
      int.parse(day),
      amPm ? int.parse(hr) : int.parse(hr) + 12,
      int.parse(min),
    );
    final iD = int.parse(dateNow.millisecond.toString());
    notifyTask.scheduleNotification(
        iD, taskDateTime, doThis.toString(), categoryName.toString());
  }

  updateTodo(categoryName, todos, bool isDone, doThis, hr, min, bool amPm, day,
      mon, year) {
    final userData = box.get('todoGoUser');
    final category = userData.categories
        .firstWhere((category) => category.name == categoryName);
    if (category != null) {
      final index = category.tasks.indexWhere((task) => task.todos == todos);
      if (index >= 0) {
        category.tasks[index].todos = doThis;
        category.tasks[index].isDone = isDone;
        category.tasks[index].hour = hr;
        category.tasks[index].minute = min;
        category.tasks[index].isAM = amPm;
        category.tasks[index].day = day;
        category.tasks[index].month = mon;
        category.tasks[index].year = year;
        box.put('todoGoUser', userData);
      }
    }
  }

  deleteTodo(categoryName, todos) {
    final userData = box.get('todoGoUser');
    final category = userData.categories
        .firstWhere((category) => category.name == categoryName);
    if (category != null) {
      final index = category.tasks.indexWhere((task) => task.todos == todos);
      if (index >= 0) {
        category.tasks.removeAt(index);
      }
    }
    box.put('todoGoUser', userData);
  }

  getAllTodos() {
    final todogo = box.get('todoGoUser');
    final categories = todogo.categories;

    List<Todos> taskToRemind = [];

    for (var category in categories) {
      for (var todos in category.tasks) {
        if (todos != null) {
          String task = todos.todos;
          int hour = int.parse(todos.hour);
          int minute = int.parse(todos.minute);
          bool isAM = todos.isAM;
          int day = int.parse(todos.day);
          int month = int.parse(todos.month);
          int year = int.parse(todos.year);

          var taskDateTime = tz.TZDateTime(
            philippineTimeZone,
            year,
            month,
            day,
            isAM ? hour : hour + 12,
            minute,
          );
          taskToRemind.add(Todos(
              categoryName: category.name,
              todos: task,
              reminderTime: taskDateTime));
        }
      }
    }
    return taskToRemind;
  }
}
