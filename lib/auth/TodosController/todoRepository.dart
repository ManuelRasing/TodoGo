import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/todos.dart';

class TodoRepository extends GetxController {
  static TodoRepository get instance => Get.find();

  final _userDb = FirebaseFirestore.instance.collection('Users');

  Future<List<Todos>> getAllTodos(userID, String categoryName) async {
    final snapshot = await _userDb
        .doc(userID)
        .collection('TaskCategories')
        .doc(categoryName)
        .collection('Todos')
        .get();

    final userTodos = snapshot.docs.map((e) => Todos.fromSnapshot(e)).toList();
    return userTodos;
  }

  isDone(String userID, String categoryName, String todoID, updatedVal, todo) {
    final docRef = _userDb
        .doc(userID)
        .collection('TaskCategories')
        .doc(categoryName)
        .collection('Todos')
        .doc(todoID);
    docRef.update({'isDone': updatedVal}).then((_) {
      Get.snackbar(updatedVal ? 'Done' : 'Undone', todo.toString(),
          snackPosition: SnackPosition.TOP);
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString(),
          snackPosition: SnackPosition.TOP);
    });
  }

  addTodos(userID, categoryName, doThis, hr, min, amPm, day, mon, year) async {
    await _userDb
        .doc(userID)
        .collection('TaskCategories')
        .doc(categoryName)
        .collection('Todos')
        .doc()
        .set({
      'isDone': false,
      'todo': doThis,
      'whatTimehr': hr.toString(),
      'whatTimemin': min.toString(),
      'isAm': amPm,
      'whatDay': day.toString(),
      'whatMonth': mon.toString(),
      'whatYear': year.toString(),
    }).then((_) {
      Get.snackbar('Success', 'New todo task created',
          snackPosition: SnackPosition.TOP);
    }).catchError((onError) {
      Get.snackbar("Error", onError.toString(),
          snackPosition: SnackPosition.TOP);
    });
  }
}
