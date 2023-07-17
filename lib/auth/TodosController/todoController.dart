import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:todo_app/auth/TodosController/todoRepository.dart';

class TodoController extends GetxController {
  static TodoController get instance => Get.find();

  final _todoRepo = Get.put(TodoRepository());

  final doThisController = TextEditingController();
  final hrController = TextEditingController();
  final minController = TextEditingController();
  final dayController = TextEditingController();
  final monController = TextEditingController();
  final yearController = TextEditingController();

  addTodo(categoryName, doThis, hr, min, amPm, day, mon, year) {
    return _todoRepo.addTodos(
        categoryName, doThis, hr, min, amPm, day, mon, year);
  }

  editTask(categoryName, todos, bool isDone, doThis, hr, min, bool amPm, day,
      mon, year) {
    return _todoRepo.updateTodo(
        categoryName, todos, isDone, doThis, hr, min, amPm, day, mon, year);
  }

  deleteTask(categoryName, todos) {
    return _todoRepo.deleteTodo(categoryName, todos);
  }
}
