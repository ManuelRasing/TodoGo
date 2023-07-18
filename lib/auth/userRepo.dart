import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/userModel.dart';
import '../offline_database/database.dart';
import 'taskCatRepository.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();
  final random = Random();

  final _db = FirebaseFirestore.instance.collection('Users');
  final taskCatRepo = Get.put(TaskCatRepo());
  final box = Hive.box('todogoBox');
  DateTime dateNow = DateTime.now();
  isAm(int dateNow) {
    if (dateNow > 12) {
      return true;
    } else {
      return false;
    }
  }

  createUser(UserModel user, username) async {
    final uniqueId = random.nextInt(999999);
    var categoryList = <TodoCategory>[];
    final categories = [
      'Personal',
      'Health and Fitness',
      'Educational',
      'Work',
      'Home',
      'Finance',
      'Shopping',
      'Social',
      'Hobbies',
      'Travel',
    ];
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
    try {
      await _db.add(user.toJson()).then((DocumentReference doc) async {
        for (final category in categories) {
          try {
            categoryList.add(TodoCategory(name: category, tasks: [task1]));
            await _db
                .doc(doc.id)
                .collection('TaskCategories')
                .doc(category)
                .set({}).then((_) async {
              await _db
                  .doc(doc.id)
                  .collection('TaskCategories')
                  .doc(category)
                  .collection('Todos')
                  .doc('Sample-todo')
                  .set({
                'isDone': false,
                'todos': 'Make your first todo task.',
                'hour': DateFormat('hh').format(dateNow).toString(),
                'minute': DateFormat('mm').format(dateNow).toString(),
                'isAM': isAm(int.parse(DateFormat('HH').format(dateNow))),
                'day': DateFormat('dd').format(dateNow).toString(),
                'month': dateNow.month.toString(),
                'year': dateNow.year.toString(),
                'todoID': uniqueId.toString()
              });
            });
          } catch (e) {
            print("ERROR CREATING CATEGORY: $e");
          }
        }
      });
    } catch (e) {
      print("ERROR CREATING USER: $e");
    }
    final _todoGo = TodoGo(username: username, categories: categoryList);
    box.put('todoGoUser', _todoGo);
    print("user created!!");
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
    //   }).whenComplete(() {
    //     Get.snackbar('Success', 'User successfully created.',
    //         snackPosition: SnackPosition.TOP);
    //   });
    // } catch (_) {
    //   Get.snackbar('Error', 'Please try again.',
    //       snackPosition: SnackPosition.TOP);
    // }
  }
}
