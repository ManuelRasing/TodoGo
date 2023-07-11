import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/taskCategory.dart';

class TaskCatRepo extends GetxController {
  static TaskCatRepo get instance => Get.find();

  final _userDb = FirebaseFirestore.instance.collection('Users');
  DateTime dateNow = DateTime.now();
  isAm(int dateNow) {
    if (dateNow > 12) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createCategories(String userId) async {
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

    try {
      for (final category in categories) {
        await _userDb
            .doc(userId)
            .collection('TaskCategories')
            .doc(category)
            .set({}).then((_) {
          _userDb
              .doc(userId)
              .collection('TaskCategories')
              .doc(category)
              .collection('Todos')
              .doc('Sample-todo')
              .set({
            'isDone': false,
            'todo': 'Make your first todo task.',
            'whatTimehr': DateFormat('hh').format(dateNow).toString(),
            'whatTimemin': DateFormat('mm').format(dateNow).toString(),
            'isAm': isAm(int.parse(DateFormat('HHs').format(dateNow))),
            'whatDay': DateFormat('dd').format(dateNow).toString(),
            'whatMonth': dateNow.month.toString(),
            'whatYear': dateNow.year.toString(),
          });
        });
      }
    } catch (_) {
      // Handle any errors here
    }
  }

  addCategory(userid, String categoryName) async {
    try {
      await _userDb
          .doc(userid)
          .collection('TaskCategories')
          .doc(categoryName)
          .set({}).then((_) {
        _userDb
            .doc(userid)
            .collection('TaskCategories')
            .doc(categoryName)
            .collection('Todos')
            .doc('Sample-todo')
            .set({
          'isDone': false,
          'todo': 'Make your first todo task.',
          'whatTimehr': DateFormat('hh').format(dateNow).toString(),
          'whatTimemin': DateFormat('mm').format(dateNow).toString(),
          'isAm': isAm(int.parse(DateFormat('HHs').format(dateNow))),
          'whatDay': DateFormat('dd').format(dateNow).toString(),
          'whatMonth': dateNow.month.toString(),
          'whatYear': dateNow.year.toString(),
        }).whenComplete(() {
          Get.snackbar('Success', 'Category added.',
              snackPosition: SnackPosition.TOP);
        });
      });
    } catch (_) {
      Get.snackbar('Error', 'Please try again.',
          snackPosition: SnackPosition.TOP);
    }
  }

  editCategory(userId, String categoryName, String newName) async {
    try {
      await _userDb
          .doc(userId)
          .collection('TaskCategories')
          .doc(categoryName)
          .delete()
          .whenComplete(() async {
        await _userDb
            .doc(userId)
            .collection('TaskCategories')
            .doc(newName)
            .collection('Todos')
            .add({}).whenComplete(() {
          Get.snackbar('Success', 'Category changed.',
              snackPosition: SnackPosition.TOP);
        });
      });
    } catch (_) {
      Get.snackbar('Error', 'Please try again.',
          snackPosition: SnackPosition.TOP);
    }
  }

  deleteCategory(userId, String categoryName) async {
    try {
      await _userDb
          .doc(userId)
          .collection('TaskCategories')
          .doc(categoryName)
          .delete()
          .whenComplete(() {
        Get.snackbar('Success', 'Category deleted.',
            snackPosition: SnackPosition.TOP);
      });
    } catch (_) {
      Get.snackbar('Error', 'Please try again.',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<List<TaskCategory>> getCategories(userID) async {
    final snapshot =
        await _userDb.doc(userID).collection('TaskCategories').get();
    final userCategories =
        snapshot.docs.map((e) => TaskCategory.fromSnapshot(e)).toList();
    print("$userID  \n$userCategories \n${snapshot.docs}");
    return userCategories;
  }
}
