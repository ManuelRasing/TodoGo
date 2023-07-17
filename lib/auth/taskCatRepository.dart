import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/offline_database/database.dart';

class TaskCatRepo extends GetxController {
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
    final task1 = Task(
        todos: 'Make your first todo task.',
        isDone: false,
        hour: DateFormat('hh').format(dateNow).toString(),
        minute: DateFormat('mm').format(dateNow).toString(),
        isAM: isAm(int.parse(DateFormat('HH').format(dateNow))),
        day: DateFormat('dd').format(dateNow).toString(),
        month: dateNow.month.toString(),
        year: dateNow.year.toString());

    final userData = box.get('todoGoUser');
    final newCategory = TodoCategory(name: categoryName, tasks: [task1]);
    userData.categories.add(newCategory);
    box.put("todoGoUser", userData);
  }

  editCategory(String categoryName) {
    final userData = box.get('todoGoUser');
    final index = userData.categories
        .indexWhere((category) => category.name == categoryName);
    if (index >= 0) {
      userData.categories.removeAt(index);
    }
    box.put("todoGoUser", userData);
  }

  deleteCategory(String categoryName) async {
    final userData = box.get('todoGoUser');
    final index = userData.categories
        .indexWhere((category) => category.name == categoryName);
    if (index >= 0) {
      userData.categories.removeAt(index);
    }
    box.put("todoGoUser", userData);
  }
}
