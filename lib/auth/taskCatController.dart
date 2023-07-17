import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/taskCatRepository.dart';

class TaskCatController extends GetxController {
  static TaskCatController get instance => Get.find();

  final addCatController = TextEditingController();
  final editCatController = TextEditingController();

  final _taskCatRepo = Get.put(TaskCatRepo());

  addCategory(categoryName) {
    return _taskCatRepo.addCategory(categoryName);
  }

  editCategory(String categoryName) {
    return _taskCatRepo.deleteCategory(categoryName);
  }
}
