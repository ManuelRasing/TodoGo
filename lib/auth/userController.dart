

import 'package:get/get.dart';
import 'package:todo_app/auth/authRepository.dart';
import 'package:todo_app/auth/userRepo.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();

  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepo());

  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserInfo(email);
    } else {
      return Get.snackbar('Error', 'No email found',
      snackPosition: SnackPosition.TOP,
      );
    }
  }
}