import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/auth/authRepository.dart';

class SyncAppFirebase extends GetxController {
  static SyncAppFirebase get instance => Get.find();
  final _authRepo = Get.put(AuthRepository());

  final box = Hive.box('todogoBox');
  syncDatabase(email) async {
    final userID = await _authRepo.getUserID(email);
    final _userDb = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userID)
        .collection("TaskCategories")
        .get();
    if (_userDb.docs.isNotEmpty) {
      for (var doc in _userDb.docs) {
        final todos = await doc.reference.collection("Todos").get();
        for (var doc in todos.docs) {
          doc.reference.delete();
        }
        doc.reference.delete();
      }
    }
    final userData = box.get('todoGoUser');
    for (var category in userData.categories) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .collection("TaskCategories")
          .doc(category.name)
          .set({});
      for (var task in category.tasks) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userID)
            .collection("TaskCategories")
            .doc(category.name)
            .collection("Todos")
            .doc()
            .set({
          'todos': task.todos,
          'isDone': task.isDone,
          'hour': task.hour,
          'minute': task.minute,
          'isAM': task.isAM,
          'day': task.day,
          'month': task.month,
          'year': task.year,
        });
      }
    }
    Get.snackbar('Yay! Sync complete', 'Account updated successfully.',
        snackPosition: SnackPosition.TOP);
  }
}
