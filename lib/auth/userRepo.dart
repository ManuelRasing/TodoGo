
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/userModel.dart';
import 'taskCatRepository.dart';

class UserRepo extends GetxController{
  static UserRepo get instance => Get.find();

  final _db = FirebaseFirestore.instance.collection('Users');
  final taskCatRepo = Get.put(TaskCatRepo());


  createUser(UserModel user) async {
    try{
      await _db.add(user.toJson()).then((DocumentReference doc) {
        taskCatRepo.createCategories(doc.id);
      }).whenComplete(() {
        Get.snackbar('Success', 'User successfully created.',
        snackPosition: SnackPosition.TOP);

    });
    }catch(_){
      Get.snackbar('Error', 'Please try again.',
      snackPosition: SnackPosition.TOP);
    }
  }

  Future<UserModel> getUserInfo(String email) async{
    final snapshot = await _db.where('Email', isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }
}