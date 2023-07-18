import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
          'todoID': task.todoID
        });
      }
    }
    Get.snackbar('Yay! Sync complete', 'Account updated successfully.',
        snackPosition: SnackPosition.TOP,
        icon: Image.asset(
          'assets/images/yay.gif',
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
