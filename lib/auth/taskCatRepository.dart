import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/offline_database/database.dart';

class TaskCatRepo extends GetxController {
  final random = Random();

  static TaskCatRepo get instance => Get.find();
  final box = Hive.box('todogoBox');
  DateTime dateNow = DateTime.now();
  isAm(int dateNow) {
    if (dateNow > 12) {
      return true;
    } else {
      return false;
    }
  }

  addCategory(String categoryName) {
    final uniqueId = random.nextInt(999999);
    final task1 = Task(
        todos: 'Make your first todo task.',
        isDone: false,
        hour: DateFormat('hh').format(dateNow).toString(),
        minute: DateFormat('mm').format(dateNow).toString(),
        isAM: isAm(int.parse(DateFormat('HH').format(dateNow))),
        day: DateFormat('dd').format(dateNow).toString(),
        month: dateNow.month.toString(),
        year: dateNow.year.toString(),
        todoID: uniqueId);

    final userData = box.get('todoGoUser');
    final newCategory = TodoCategory(name: categoryName, tasks: [task1]);
    userData.categories.add(newCategory);
    box.put("todoGoUser", userData);

    Get.snackbar('$categoryName Category Added.',
        'Make your first task in $categoryName.',
        snackPosition: SnackPosition.TOP,
        icon: Image.asset(
          'assets/images/folder.gif',
          height: 50,
          width: 50,
        ),
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        duration: Duration(seconds: 5),
        borderRadius: 10,
        colorText: Color(0xffF5F3C1),
        backgroundColor: Color(0x830EA293));
  }

  deleteCategory(String categoryName) async {
    final userData = box.get('todoGoUser');
    final index = userData.categories
        .indexWhere((category) => category.name == categoryName);
    if (index >= 0) {
      userData.categories.removeAt(index);
    }
    box.put("todoGoUser", userData);
    Get.snackbar('$categoryName Category Removed.', 'Make new category.',
        snackPosition: SnackPosition.TOP,
        icon: Image.asset(
          'assets/images/deletedTask.gif',
          height: 50,
          width: 50,
        ),
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        duration: Duration(seconds: 5),
        borderRadius: 10,
        colorText: Color(0xffF5F3C1),
        backgroundColor: Color(0x830EA293));
  }
}
