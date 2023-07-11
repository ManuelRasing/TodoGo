import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/userRepo.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepo());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _userRepo.getUserInfo(email);
    } else {
      return Get.snackbar(
        'Error',
        'No email found',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<String> getUserID() async {
    final email = _authRepo.firebaseUser.value?.email;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get();
    String userID = snapshot.docs[0].id;
    return userID;
  }
}
