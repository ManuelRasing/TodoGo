import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/taskCatRepository.dart';
import 'package:todo_app/auth/userRepo.dart';
import 'package:todo_app/models/taskCategory.dart';

class TaskCatController extends GetxController{
  static TaskCatController get instance => Get.find();

  final addCatController = TextEditingController();

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
}