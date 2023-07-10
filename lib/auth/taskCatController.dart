import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/taskCatRepository.dart';
import 'package:todo_app/models/taskCategory.dart';

class TaskCatController extends GetxController{
  static TaskCatController get instance => Get.find();

  final addCatController = TextEditingController();
  final editCatController = TextEditingController();

  final _authRepo = Get.put(AuthRepository());
  final _taskCatRepo = Get.put(TaskCatRepo());
  
  final _db = FirebaseFirestore.instance.collection('Users');

  Future<List<TaskCategory>> getAllCategory() async{
    final email = _authRepo.firebaseUser.value?.email;
    QuerySnapshot snapshot = await _db.where('Email', isEqualTo: email).get();
    String userID = snapshot.docs[0].id;
    return await _taskCatRepo.getCategories(userID);
  }
  Future addCategory(String categoryName) async{
    final email = _authRepo.firebaseUser.value?.email;
    QuerySnapshot snapshot = await _db.where('Email', isEqualTo: email).get();
    String userID = snapshot.docs[0].id;
    return await _taskCatRepo.addCategory(userID, categoryName);
  }
  Future editCategory(String categoryName, String newName, bool isEdit) async{
    final email = _authRepo.firebaseUser.value?.email;
    QuerySnapshot snapshot = await _db.where('Email', isEqualTo: email).get();
    String userID = snapshot.docs[0].id;
    if(isEdit){
      return await _taskCatRepo.editCategory(userID,categoryName, newName);
    }else{
      return await _taskCatRepo.deleteCategory(userID, categoryName);
    }
  }
}