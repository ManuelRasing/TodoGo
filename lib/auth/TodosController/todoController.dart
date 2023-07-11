import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:todo_app/auth/TodosController/todoRepository.dart';
import 'package:todo_app/auth/userController.dart';
import 'package:todo_app/models/todos.dart';

class TodoController extends GetxController {
  static TodoController get instance => Get.find();

  final _todoRepo = Get.put(TodoRepository());
  final _userController = Get.put(UserController());

  final doThisController = TextEditingController();
  final hrController = TextEditingController();
  final minController = TextEditingController();
  final dayController = TextEditingController();
  final monController = TextEditingController();
  final yearController = TextEditingController();

  Future<List<Todos>> getAllTodos(categoryName) async {
    final userID = await _userController.getUserID();
    return _todoRepo.getAllTodos(userID, categoryName);
  }

  updateIsDone(categoryName, todoID, updatedVal, todo) async {
    final userID = await _userController.getUserID();
    return _todoRepo.isDone(userID, categoryName, todoID, updatedVal, todo);
  }

  addTodo(categoryName, doThis, hr, min, amPm, day, mon, year) async {
    String userID = await _userController.getUserID();
    return _todoRepo.addTodos(
        userID, categoryName, doThis, hr, min, amPm, day, mon, year);
  }
}
