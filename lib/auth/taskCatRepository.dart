
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/taskCategory.dart';

class TaskCatRepo extends GetxController{
  static TaskCatRepo get instance => Get.find();

  
  final _userDb = FirebaseFirestore.instance.collection('Users');


  createCategories(userid) async{
    await _userDb.doc(userid).collection('TaskCategories').doc('Personal').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Health and Fitness').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Educational').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Work').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Home').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Finance').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Shopping').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Social').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Hobbies').set({});
    await _userDb.doc(userid).collection('TaskCategories').doc('Travel').set({});
  }

  addCategory(userid, String categoryName) async{
    try{
      await _userDb.doc(userid).collection('TaskCategories').doc(categoryName).set({}).whenComplete(() {
      Get.snackbar('Success', 'Category added.',
      snackPosition: SnackPosition.TOP);
    });
    }catch(_){
      Get.snackbar('Error', 'Please try again.',
      snackPosition: SnackPosition.TOP);
    }
  }

  Future<List<TaskCategory>> getCategories(userID) async{
    final snapshot = await _userDb.doc(userID).collection('TaskCategories').get();
    final userCategories = snapshot.docs.map((e) => TaskCategory.fromSnapshot(e)).toList();
    return userCategories;
  }
}